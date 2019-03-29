package com.stratio.marathonlbsec.functionalAT;

import com.stratio.qa.cucumber.testng.CucumberRunner;
import com.stratio.tests.utils.BaseTest;
import cucumber.api.CucumberOptions;
import org.testng.annotations.Test;

@CucumberOptions(features = { "src/test/resources/features/functionalAT/030_Logs/03_QATM_2113_Vault_Renewal_Token.feature" },format = "json:target/cucumber.json")
public class QATM_2113_Vault_Renewal_Token_IT extends BaseTest {

    public QATM_2113_Vault_Renewal_Token_IT() {

    }

    @Test(enabled = true, groups = {"vaultRenewalToken"})
    public void QATM1386_Certificates() throws Exception {
        new CucumberRunner(this.getClass()).runCukes();
    }
}
