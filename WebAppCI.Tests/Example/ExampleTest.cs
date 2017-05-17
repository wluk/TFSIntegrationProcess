using System;
using System.IO;
using System.Threading;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;

namespace WebAppCI.Tests.Example
{
    [TestClass]
    public class ExampleTest
    {
#if DEBUG
        public const string RELATIVE_UI_TESTS_FOLDER_PATH = @"tests\Yellow.UITests\bin\Debug";
        public const string CHROME_PORTABLE_PATH = @"\..\..\..\tools\ChromePortable\GoogleChromePortable.exe";
        public const string CHROME_DRIVER_PATH = @"\..\..\..\packages\Selenium.WebDriver.ChromeDriver.2.28.0\driver\";
        public const string FIREFOX_PORTABLE_PATH = @"\..\..\tools\FirefoxPortable\FirefoxPortable.exe";
#else   
        public const string RELATIVE_UI_TESTS_FOLDER_PATH = @"dependency-artifacts\bin\Yellow.UITests";
        public const string CHROME_PORTABLE_PATH = @"\..\..\..\tools\ChromePortable\GoogleChromePortable.exe";
        public const string CHROME_DRIVER_PATH = @"\..\..\..\packages\Selenium.WebDriver.ChromeDriver.2.28.0\driver\";
        public const string FIREFOX_PORTABLE_PATH = @"\..\..\..\tools\FirefoxPortable\FirefoxPortable.exe"; 
#endif
        public static IWebDriver browser;

        [TestMethod]
        public void TestMethod()
        {
            browser = CreateChromeBrowserInstance();

            browser.Navigate().GoToUrl("http://bing.com");

            Thread.Sleep(3000);
            browser.Close();
        }

        static IWebDriver CreateChromeBrowserInstance()
        {
            var downloadedFileDirectoryPath = AppDomain.CurrentDomain.BaseDirectory + "\\DownloadedFiles";
            Directory.CreateDirectory(downloadedFileDirectoryPath);
            var fullChromePortablePath = AppDomain.CurrentDomain.BaseDirectory + ExampleTest.CHROME_PORTABLE_PATH;
            fullChromePortablePath = Path.GetFullPath(fullChromePortablePath);
            var fullChromeDriverPath = AppDomain.CurrentDomain.BaseDirectory + ExampleTest.CHROME_DRIVER_PATH;
            fullChromeDriverPath = Path.GetFullPath(fullChromeDriverPath);
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
