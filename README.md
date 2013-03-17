# ayah-sfdc

Add [are you a human](http://areyouahuman.com/) to visualforce pages. You can check out a [live demo here](http://ayah-developer-edition.na15.force.com/).

![Ayah SFDC](http://dl.dropbox.com/u/21549383/ayah-sfdc.png "Are you a Human for Salesforce")

## Setup

1. Install `Ayah.cls` into your Salesforce Org
2. Under **Setup->Remote Site Settings**, add **https://ws.areyouahuman.com**

## Usage

Initialize an **Ayah** object with your `publisher key` and your `scoring key`

```java
Ayah myAyah = new Ayah('mypublisherkey', 'myscoringkey');
```

Calling `getPublisherHtml` will generate the html you need to drop into a page. You can do this in an `apex:outputText` with `escape="false"`

```html
<apex:outputText value="{!myAyah.publisherHtml}" escape="false" />
```

Then, in your controller, get the `session_secret` parameter value. This is what we need to send to the service to check if the **PlayThru** was successful. Call the `getScore` method with the `session_secret` to see if we are successful or not. 

```java
public PageReference checkUserScore() {

  String sessionSecret = ApexPages.currentPage().getParameters().get('session_secret');

  if(sessionSecret == null) {
    addError('No session secret found');
    return null;
  } 

  // call the getScore method to see if the PlayThru was successful
  if(ayah.getScore(sessionSecret)) {
    addInfo('Congrats! You are a human!');
  } else {
    addError('Sorry, you are not a human!');
  }

  return null;

}
```

## Demo

[Check out this demo page](http://ayah-developer-edition.na15.force.com/)

The demo files used are also included in this repo.