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
		Assert.assertEquals(new HomeController().getAPrioriRisk("30", "30", "13"), "16722");
	}
	
//	@Test
//	public void compile() throws IOException
//	{
//		StringBuffer output = new StringBuffer();
//		 
//		Process p;
//		try {
//			p = Runtime.getRuntime().exec("ls;");
//			p.waitFor();
//			BufferedReader reader = 
//                            new BufferedReader(new InputStreamReader(p.getInputStream()));
// 
//                        String line = "";			
//			while ((line = reader.readLine())!= null) {
//				output.append(line + "\n");
//			}
// 
//		} catch (Exception e) {
//			System.err.println(">> ERROR! >>");
//			e.printStackTrace();
//		}
//		System.out.println(">> NO ERROR");
// 
//		System.out.println(" >> " + output.toString());
////		System.out.println(executeCommand("cd src/main/resources/delphi;ls"));
//		//fpc -Mdelphi src/main/resources/delphi/commandline_risk_nipt_augustus.dpr
//		assertTrue(true);
//	}
//
//	private String executeCommand(String command) {
//		 
//		StringBuffer output = new StringBuffer();
// 
//		Process p;
//		try {
//			p = Runtime.getRuntime().exec(command);
//			p.waitFor();
//			BufferedReader reader = 
//                            new BufferedReader(new InputStreamReader(p.getInputStream()));
// 
//                        String line = "";			
//			while ((line = reader.readLine())!= null) {
//				output.append(line + "\n");
//			}
// 
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
// 
//		return output.toString();
// 
//	}
}
