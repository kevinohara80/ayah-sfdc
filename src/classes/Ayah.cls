public class Ayah {
	
  /************************************
   * private properties
   ************************************/

  private String wsHost;
  private String pubKey;
  private String scoreKey;

  /************************************
   * constructor
   ************************************/

  public Ayah(String pubKey, String scoreKey) {
    this.pubKey = pubKey;
    this.scoreKey = scoreKey;
    this.wsHost = 'ws.areyouahuman.com';
	}

  public Ayah(String pubKey, String scoreKey, String wsHost) {
    this.pubKey = pubKey;
    this.scoreKey = scoreKey;
    this.wsHost = wsHost;
  }

  /************************************
   * getters/setters
   ************************************/

  public String getPubKey() {
    return this.pubKey;
  }

  public void setPubKey(String pubKey) {
    this.pubKey = pubKey;
  }

  public String getScoreKey() {
    return this.pubKey;
  }

  public void setScoreKey(String scoreKey) {
    this.scoreKey = scoreKey;
  }

  public String getWSHost() {
    return this.wsHost;
  }

  public void setWSHost(String wsHost) {
    this.wsHost = wsHost;
  }

  /************************************
   * public api
   ************************************/

  public Boolean getScore(String sessionSecret) {

    // return false if the sessionSecret is false
    if(sessionSecret == null) return false;

    String body = 'session_secret=' 
      + EncodingUtil.urlEncode(sessionSecret, 'UTF-8')
      + '&scoring_key=' 
      + EncodingUtil.urlEncode(this.scoreKey, 'UTF-8');

    Http h = new Http();
    
    HttpRequest req = new HttpRequest();
    req.setEndpoint('https://' + this.wsHost + '/ws/scoreGame');
    req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    req.setBody(body);
    req.setMethod('POST');

    HttpResponse res = h.send(req);

    System.debug('AYAH SESS SEC: ' + sessionSecret);
    System.debug('AYAH REQ BODY: ' + req.getBody());
    System.debug('AYAH RES CODE: ' + res.getStatusCode());
    System.debug('AYAH RES BODY: ' + res.getBody());

    // return false if we get anything other than 200
    if(res.getStatusCode() != 200) return false;

    AyahResponse ayahResp;
    
    try {
      ayahResp = (AyahResponse) JSON.deserialize(res.getBody(), AyahResponse.class);
    } catch (Exception e) {
      return false;
    }
    
    // response code of 1 means score was successful
    if(ayahResp.status_code == 1) return true;

    // otherwise, return false
    return false;

  }

  public String getPublisherHtml() {
    
    String url = 'https://' + this.wsHost + '/ws/script/' + EncodingUtil.urlEncode(this.pubKey, 'UTF-8');
    String html = '<div id="AYAH"></div><script src="' + url + '" type="text/javascript" language="JavaScript"></script>';
    
    return html;
  }

  /************************************
   * private classes
   ************************************/

  private class AyahResponse {
    public Integer status_code;
  }


}