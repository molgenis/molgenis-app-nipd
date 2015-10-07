package org.molgenis.nipd.controller;

import java.io.IOException;

import org.molgenis.util.FileStore;
import org.springframework.beans.factory.annotation.Autowired;
import org.testng.Assert;
import org.testng.annotations.Test;

public class NiptDiagnoserTest
{

	@Autowired
	FileStore fileStore;
	
	@Test
	public void getAPrioriRiskTest() throws IOException
	{
//		Assert.assertEquals(new HomeController(fileStore).getAPrioriRisk("13", "20", "20"), "14656");
	}
	

	@Test
	public void getRiskTest() throws IOException
	{
//		Assert.assertEquals(new HomeController(fileStore).getRisk("2", "30", ".5", "4", ".001"), "20.7"); // "0.2070116"
	}
	
}
