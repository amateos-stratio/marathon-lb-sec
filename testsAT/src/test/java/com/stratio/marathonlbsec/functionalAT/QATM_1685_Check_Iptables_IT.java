package com.stratio.marathonlbsec.functionalAT;

import com.stratio.qa.cucumber.testng.CucumberRunner;
import com.stratio.tests.utils.BaseTest;
import cucumber.api.CucumberOptions;
import org.testng.annotations.Test;

@CucumberOptions(features = {
        "src/test/resources/features/functionalAT/QATM_1685_Check_Iptables.feature"
})

public class QATM_1685_Check_Iptables_IT extends BaseTest {

    public QATM_1685_Check_Iptables_IT() {
    }

    @Test(enabled = true, groups = {"iptables"})
    public void QATM_1685_Check_Iptables_IT() throws Exception {
        new CucumberRunner(this.getClass()).runCukes();
    }
}
