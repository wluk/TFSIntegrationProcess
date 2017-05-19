using System;
using System.IO;
using System.Threading;
using Machine.Specifications;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Firefox;
using OpenQA.Selenium.Remote;

namespace WebAppCI.Tests.Example
{
    [TestClass]
    public class ExampleTest
    {

        public const string RELATIVE_UI_TESTS_FOLDER_PATH = @"tests\Yellow.UITests\bin\Debug";
        public const string CHROME_PORTABLE_PATH = @"\..\..\..\tools\ChromePortable\GoogleChromePortable.exe";
        public const string CHROME_DRIVER_PATH = @"\..\..\..\packages\Selenium.WebDriver.ChromeDriver.2.28.0\driver\";
        public const string FIREFOX_PORTABLE_PATH = @"\..\..\..\tools\FirefoxPortable\FirefoxPortable.exe";
        public const string FIREFOX_PROFILE_PATH = @"\..\..\..\tools\FirefoxPortable\profile\rust_mozprofile.BOLwCYe1yw1l\";
        public const string FIREFOX_DRIVER_PATH = @"\..\..\..\packages\WebDriver.GeckoDriver.0.16.0\content\";

        public static IWebDriver browser;
        public const string HOME_PAGE_MAIN_SUBJECT = "Home Page - Main";

        private Cleanup after = () =>
        {

        };

        [TestMethod]
        public void when_user_go_to_bing_com()
        {
            var choice = 3;

            switch (choice)
            {
                case 1:
                    browser = CreateChromeBrowserInstance();
                    break;
                case 2:
                    browser = CreateFirefoxBrowserInstance();
                    break;
                default:
                    DesiredCapabilities d = DesiredCapabilities.Firefox();
                    //d.SetCapability("marionette", true);
                    browser = new FirefoxDriver(d);
                    return;
            }

            try
            {

                browser.Navigate().GoToUrl("http://bing.com");

                browser.Navigate().GoToUrl("http://onet.pl");

                Thread.Sleep(2000);

                browser.Navigate().GoToUrl("http://bing.com");
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }
            finally
            {
                browser.Close();
                browser.Quit();
            }



            Thread.Sleep(3000);
        }

        private static IWebDriver CreateChromeBrowserInstance()
        {
            var downloadedFileDirectoryPath = AppDomain.CurrentDomain.BaseDirectory + "\\DownloadedFiles";
            Directory.CreateDirectory(downloadedFileDirectoryPath);
            var fullChromePortablePath = AppDomain.CurrentDomain.BaseDirectory + CHROME_PORTABLE_PATH;
            fullChromePortablePath = Path.GetFullPath(fullChromePortablePath);
            var fullChromeDriverPath = AppDomain.CurrentDomain.BaseDirectory + CHROME_DRIVER_PATH;
            fullChromeDriverPath = Path.GetFullPath(fullChromeDriverPath);
            var options = new ChromeOptions { BinaryLocation = fullChromePortablePath };
            options.AddUserProfilePreference("download.prompt_for_download", "false");
            options.AddUserProfilePreference("download.default_directory", downloadedFileDirectoryPath);
            options.AddArguments("--lang=en");
            options.AddArguments("--no-sandbox");

            IWebDriver chromeBrowser = new ChromeDriver(fullChromeDriverPath, options, Timeout.InfiniteTimeSpan);

            return chromeBrowser;
        }

        private static IWebDriver CreateFirefoxBrowserInstance()
        {

            var fullFirefoxProfilePath = AppDomain.CurrentDomain.BaseDirectory + FIREFOX_PROFILE_PATH;
            fullFirefoxProfilePath = Path.GetFullPath(fullFirefoxProfilePath);

            var profile = new FirefoxProfile()
            //var profile = new FirefoxProfile
            {
                EnableNativeEvents = true,
                AcceptUntrustedCertificates = true,
            };

            var downloadedFileDirectoryPath = AppDomain.CurrentDomain.BaseDirectory + "\\DownloadedFiles";
            Directory.CreateDirectory(downloadedFileDirectoryPath);

            profile.SetPreference("browser.download.dir", downloadedFileDirectoryPath);
            profile.SetPreference(
                "browser.helperApps.neverAsk.saveToDisk",
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,text/xlsx,text/csv,text/plain,text/html");
            profile.SetPreference("browser.download.folderList", 2);

            // in order to prevent download manager to pop up, just enable 'old mode'.

            profile.SetPreference("browser.download.useToolkitUI", true);

            var fullFirefoxPortablePath = AppDomain.CurrentDomain.BaseDirectory + FIREFOX_PORTABLE_PATH;
            fullFirefoxPortablePath = Path.GetFullPath(fullFirefoxPortablePath);
            var fullFirefoxDriverPath = AppDomain.CurrentDomain.BaseDirectory + FIREFOX_DRIVER_PATH;
            fullFirefoxDriverPath = Path.GetFullPath(fullFirefoxDriverPath);

            var options = new FirefoxOptions
            {
                BrowserExecutableLocation = fullFirefoxPortablePath,
                Profile = profile
            };

            options.SetPreference("--log", "error");

            //options.AddAdditionalCapability("webdriver.firefox.marionette", false);


            var service = FirefoxDriverService.CreateDefaultService(fullFirefoxDriverPath, "geckodriver.exe");

            IWebDriver ffBrowser = null;

            



            //Firefox internally locks port 7054 to prevent instantialization of multiple instances at the same time.
            //We are trying 5 times only to avoid an infinite while loop since there is no way to determine a number of tries other than trying if some number is "enough".
            //http://stackoverflow.com/questions/4296235/a-selenium-webdriver-exception

            for (var i = 0; i < 5; i++)
            {
                try
                {
                    // infinite Timespan because of: CCNODLE-3312 (https://github.com/seleniumhq/selenium-google-code-issue-archive/issues/5071)
                    ffBrowser = new FirefoxDriver(service, options, Timeout.InfiniteTimeSpan);
                    ffBrowser.Navigate().GoToUrl("http://bing.com");
                }
                catch (WebDriverException ex)
                {
                    Console.WriteLine(
                        $"Retrying after exception occured (port is locked by previous instance): {ex.Message}");
                }
                if (ffBrowser != null)
                    break;
            }
            return ffBrowser;
        }
    }
}