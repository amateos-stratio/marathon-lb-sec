package com.stratio.marathonlbsec.functionalAT;

import com.stratio.qa.cucumber.testng.CucumberRunner;
import com.stratio.tests.utils.BaseTest;
import cucumber.api.CucumberOptions;
import org.testng.annotations.Test;

@CucumberOptions(features = {
        "src/test/resources/features/functionalAT/QATM_1685_Invalid_Password.feature"
})

public class QATM_1685_Invalid_Password_IT extends BaseTest {

    public QATM_1685_Invalid_Password_IT() {
    }

    @Test(enabled = true, groups = {"invalid_password"})
    public void QATM_1685_Invalid_Password() throws Exception {
        new CucumberRunner(this.getClass()).runCukes();
    }
}