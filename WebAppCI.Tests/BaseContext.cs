using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Machine.Specifications;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using WebAppCI.Tests.Example;

namespace WebAppCI.Tests
{
    public class BaseContext
    {
        public static IWebDriver browser;
        static string browserType = "chrome";

        static BaseContext()
        {
            browser = Browser;
        }

        static IWebDriver Browser
        {
            get
            {
                if (browser == null)
                {
                    switch (browserType)
                    {
                        case "chrome":
                            browser = CreateChromeBrowserInstance();
                            break;
                        case "ie":
                            //browser = CreateIEBrowserInstance();
                            break;
                        default:
                            //browser = CreateFirefoxBrowserInstance();
                            break;
                    }
                }

                return browser;
            }
        }

        static IWebDriver CreateChromeBrowserInstance()
        {
            var downloadedFileDirectoryPath = AppDomain.CurrentDomain.BaseDirectory + "\\DownloadedFiles";
            Directory.CreateDirectory(downloadedFileDirectoryPath);
            var fullChromePortablePath = AppDomain.CurrentDomain.BaseDirectory + ExampleTest.CHROME_PORTABLE_PATH;
            var fullChromeDriverPath = AppDomain.CurrentDomain.BaseDirectory + ExampleTest.CHROME_DRIVER_PATH;
            fullChromePortablePath = Path.GetFullPath(fullChromePortablePath);
            var options = new ChromeOptions { BinaryLocation = fullChromePortablePath };
            options.AddUserProfilePreference("download.prompt_for_download", "false");
            options.AddUserProfilePreference("download.default_directory", downloadedFileDirectoryPath);
            options.AddArguments("--lang=en");
            options.AddArguments("--no-sandbox");

            IWebDriver chromeBrowser = new ChromeDriver(fullChromeDriverPath, options, Timeout.InfiniteTimeSpan);

            return chromeBrowser;
        }
    }
}
