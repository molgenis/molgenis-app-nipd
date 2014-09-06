package org.molgenis.nipd.controller;

import static org.testng.Assert.assertTrue;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import org.testng.Assert;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

public class NiptDiagnoserTest
{

	@Test
	public void getAPrioriRiskTest() throws IOException
	{
		Assert.assertEquals(new HomeController().getAPrioriRisk("13", "20", "20"), "14656");
	}
	

	@Test
	public void getRiskTest() throws IOException
	{
		Assert.assertEquals(new HomeController().getRisk("2", "30", ".5", "4", ".001"), "20.7"); // "0.2070116"
	}
	
}
