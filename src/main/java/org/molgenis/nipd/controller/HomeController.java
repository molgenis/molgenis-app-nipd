package org.molgenis.nipd.controller;

import static org.molgenis.nipd.controller.HomeController.URI;
import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;
import static org.springframework.web.bind.annotation.RequestMethod.GET;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.PumpStreamHandler;
import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;
import org.apache.log4j.lf5.util.ResourceUtils;
import org.molgenis.framework.ui.MolgenisPluginController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.io.Resources;

/**
 * Controller that handles home page requests
 */
@Controller
@RequestMapping(URI)
public class HomeController extends MolgenisPluginController
{
	private static final Logger logger = Logger.getLogger(HomeController.class);
	public static final String ID = "home";
	public static final String URI = MolgenisPluginController.PLUGIN_URI_PREFIX + ID;
	private boolean onMac, onLinux, R;

	public HomeController()
	{
		super(URI);

		this.onMac = org.apache.commons.lang3.SystemUtils.IS_OS_MAC;
		this.onLinux = org.apache.commons.lang3.SystemUtils.IS_OS_LINUX;
		this.R = true;
	}

	@RequestMapping
	public String init()
	{
		return "view-home";
	}

	@RequestMapping(value = "getRisk/{llim}/{ulim}/{varcof:.+}/{zscore}/{apriori}", method = GET, produces = APPLICATION_JSON_VALUE)
	@ResponseBody
	public String getRisk(	@PathVariable("llim") String llim,
							@PathVariable("ulim") String ulim,
							@PathVariable("varcof") String varcof,
							@PathVariable("zscore") String zscore,
							@PathVariable("apriori") String apriori) throws IOException
	{
		try
		{
			String binary = "No executable";
			if (onMac) binary = "trisomy_risk_mac";
			if (onLinux) binary = "trisomy_risk_unix";
			if (R) binary = "RScript niptRisk.R";
			String pathToBinary = Resources.getResource(this.getClass(), "/r/").getPath();
			File workDir = new File(pathToBinary);

//			Double aPrioriChance = 1 / Double.valueOf(apriori);
			
			String command =  binary + " " + llim + " " + ulim + " " + varcof + " " + zscore+ " " + apriori;

			// round on two decimals
			String result = "" + ((double)  Math.round(Double.valueOf(executeCommand(command, workDir)) * 10000) / 100);
			return result;
		}
		catch (Throwable e)
		{
			logger.error(e);
			return "Something went wrong!";
		}
	}

	@RequestMapping(value = "getAPrioriRisk/{trisomyType}/{gestationalAgeWeeks}/{maternalAgeYears}", method = GET, produces = APPLICATION_JSON_VALUE)
	@ResponseBody
	public String getAPrioriRisk(@PathVariable("trisomyType") String trisomyType, @PathVariable("gestationalAgeWeeks") String gestationalAgeWeeks,
			@PathVariable("maternalAgeYears") String maternalAgeYears)
			throws IOException
	{
		try
		{
			String binary = "No executable";
			if (onMac) binary = "trisomy_a_priori_risk_mac";
			if (onLinux) binary = "trisomy_a_priori_risk_unix";
			if (R) binary = "RScript niptAPrioriRisk.R";
			String pathToBinary = Resources.getResource(this.getClass(), "/r/").getPath();
			File workDir = new File(pathToBinary);

			String command = binary + " " + trisomyType + " " + gestationalAgeWeeks + " " + maternalAgeYears;

			// return value x means a chance of 1 in x; but we want to return 1/x
			String value = executeCommand(command, workDir);

			return "" + Math.round(Double.valueOf(value));
		}
		catch (Throwable e)
		{
			e.printStackTrace();
			logger.error(e);
			return "Something went wrong! Check whether Gerard's program is chmod +x.";
		}
	}

	private String executeCommand(String command, File workDir)
	{
		ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
		CommandLine commandline = CommandLine.parse(command);
		DefaultExecutor exec = new DefaultExecutor();
		PumpStreamHandler streamHandler = new PumpStreamHandler(outputStream);
		exec.setStreamHandler(streamHandler);
		exec.setWorkingDirectory(workDir);
		try
		{
			exec.execute(commandline);
		}
		catch (IOException e)
		{
			logger.error(e);
		}
		finally
		{
			IOUtils.closeQuietly(outputStream);
		}

		return outputStream.toString().trim();
	}
}
