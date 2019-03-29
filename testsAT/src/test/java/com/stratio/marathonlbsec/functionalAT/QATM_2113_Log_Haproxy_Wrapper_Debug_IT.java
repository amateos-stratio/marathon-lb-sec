package com.stratio.marathonlbsec.functionalAT;

import com.stratio.qa.cucumber.testng.CucumberRunner;
import com.stratio.tests.utils.BaseTest;
import cucumber.api.CucumberOptions;
import org.testng.annotations.Test;

@CucumberOptions(features = { "src/test/resources/features/functionalAT/030_Logs/02_QATM_2113_Log_Haproxy_Wrapper_Debug.feature" },format = "json:target/cucumber.json")
public class QATM_2113_Log_Haproxy_Wrapper_Debug_IT extends BaseTest {

    public QATM_2113_Log_Haproxy_Wrapper_Debug_IT() {

    }

    @Test(enabled = true, groups = {"haproxyWrapperDebug"})
    public void QATM1386_Certificates() throws Exception {
        new CucumberRunner(this.getClass()).runCukes();
    }
}
