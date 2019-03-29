package com.stratio.marathonlbsec.functionalAT;

import com.stratio.qa.cucumber.testng.CucumberRunner;
import com.stratio.tests.utils.BaseTest;
import cucumber.api.CucumberOptions;
import org.testng.annotations.Test;

@CucumberOptions(features = {
        "src/test/resources/features/functionalAT/020_Certificates/04_QATM_2113_Certificates_MarathonLB_Service.feature"
},format = "json:target/cucumber.json")
public class QATM_2113_Certificates_MarathonLB_Service_IT extends BaseTest {

    public QATM_2113_Certificates_MarathonLB_Service_IT() {

    }

    @Test(enabled = true, groups = {"certsMarathonLBServ"})
    public void nightly() throws Exception {
        new CucumberRunner(this.getClass()).runCukes();
    }
}
