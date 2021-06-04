# Getting started

Make sure you have [Selenium IDE](https://www.selenium.dev/selenium-ide/) installed for firefox.

Open the Selenium IDE and open the `datagovau.side` project file. This will open up a project with all the tests.

## Useful selenium commands

These links were helpful.

- https://ui.vision/rpa/docs/selenium-ide
- https://www.selenium.dev/selenium-ide/docs/en/api/commands

Most of the commands are pretty straight forward to use. Below are a few examples that may help with some of the more tricky tests you are trying to create.

**Storing element count**

E.g count the number of `<p>` tags that have the css class of `text` and store it in a variable called `textElements`

| Command           | Target                   | Value            |
| ----------------- | ------------------------ | ---------------- |
| store xpath count | xpath=//p[@class="text"] | textElementCount |

**Echo**

Echo can be useful for debugging purpose.
If we wanted to print the variable `textElements` from the above example to the log, we can do the following.

| Command | Target              | Value |
| ------- | ------------------- | ----- |
| echo    | ${textElementCount} |       |

**Assert**

If we wanted to verify the number of `textElements` from above, we can do so by using the `assert` command. Lets say as an example there were 8 text elements. We could do the following to verify

| Command | Target           | Value |
| ------- | ---------------- | ----- |
| assert  | textElementCount | 8     |

Notice that when we are running the `assert` command, we don't need to have the `${}` wrapped around the variable name.

**Executing javascript**

It's possible to run javascript using the `execute script` command. There are many use cases for this. One such use case for data.gov.au is to extract data from text and use that to compare values.

For example on the search page, there is a piece of text that says `6,180 datasets found`. If we wanted to run a test to ensure that the number of datasets is greater than 6100, we would need to write some custom javascript.

The first step would be to get the element text using the `store text` command.

| Command    | Target              | Value            |
| ---------- | ------------------- | ---------------- |
| store text | css=.search-form.h2 | totalDatasetText |

This will store `6,180 datasets found` in a variable called `totalDatasetText`.

Lets say we wanted to test whether the total number of datasets found was greater than 6000. The first step would be to extract `6180` out of the text `6,180 datasets found`, using regex.

We can then use the comparison operator and store it as a variable.

| Command            | Target                                                 | Value             |
| ------------------ | ------------------------------------------------------ | ----------------- |
| execute javascript | return ${totalDatasets}.match(/\d+/g).join("") >= 5800 | totalDatasetCount |
| assert             | totalDatasetCount                                      | true              |

**Storing child element count**

To find the count of all `<li>` under the element `<ul class="dataset list">`, run the following.

| Command           | Target                               | Value            |
| ----------------- | ------------------------------------ | ---------------- |
| store xpath count | xpath=//ul[@class="dataset list"]/li | listElementCount |
