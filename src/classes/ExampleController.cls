public with sharing class ExampleController {
   
  public String firstName { get; set; }
  public String lastName { get; set; }
  public String email { get; set; }

  private Ayah ayah;

  public ExampleController() {
    this.ayah = new Ayah('<yourpublisherkey>', '<yourscoringkey>');
  }

  public String getPublisherHtml() {
    return ayah.getPublisherHtml();
  }

  public PageReference check() {

    String sessionSecret = ApexPages.currentPage().getParameters().get('session_secret');

    if(sessionSecret == null) {
      addError('No session secret found');
      return null;
    } 

    if(ayah.getScore(sessionSecret)) {
      addInfo('Congrats! You are a human!');
    } else {
      addError('Sorry, you are not a human!');
    }

    return null;
  }

  private void addInfo(String msg) {
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, msg));
  }

  private void addError(String msg) {
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, msg));
  }

}