package org.molgenis.nipd.controller;

import static org.molgenis.nipd.controller.HomeController.URI;
import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;
import static org.springframework.web.bind.annotation.RequestMethod.GET;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.PumpStreamHandler;
import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;
import org.molgenis.framework.ui.MolgenisPluginController;
import org.molgenis.util.FileStore;
import org.springframework.beans.factory.annotation.Autowired;
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

	@Autowired
	public HomeController(FileStore fileStore) throws IOException
	{
		super(URI);

		String pathToBinary = Resources.getResource(this.getClass(), "/r/").getPath();
		File workDir = new File(pathToBinary);
		for (File f : workDir.listFiles())
		{
			FileInputStream fis = new FileInputStream(f);
			fileStore.store(fis, f.getName());
			fis.close();
		}
	}

	@RequestMapping
	public String init()
	{
		return "view-home";
	}
}
