package buttso.demo.weblogic.maven;

import com.bea.core.repackaged.springframework.util.Assert;
import javax.inject.Inject;
import org.jboss.arquillian.container.test.api.Deployment;
import org.jboss.arquillian.junit.Arquillian;
import org.jboss.shrinkwrap.api.ShrinkWrap;
import org.jboss.shrinkwrap.api.asset.EmptyAsset;
import org.jboss.shrinkwrap.api.spec.JavaArchive;
import org.junit.Test;
import org.junit.runner.RunWith;

/**
 *
 * Simple test case to verify behavior of EJB component
 * Uses @Inject to inject bean to test
 * 
 * @author sbutton
 */
@RunWith(Arquillian.class)
public class AccountBeanTest {

    @Inject
    AccountBean accountBean;
       
    @Deployment
    public static JavaArchive createDeployment() {
        JavaArchive jar = ShrinkWrap.create(JavaArchive.class)
                .addClass(AccountBean.class)
                .addAsManifestResource(EmptyAsset.INSTANCE, "beans.xml");
        return jar;
    }

    @Test
    public void test_account_bean_was_deployed() {
        Assert.notNull(accountBean, "AccountBean was not injected, is null");
        System.out.println("\n\n---> HERE <---\n");
    }

}
