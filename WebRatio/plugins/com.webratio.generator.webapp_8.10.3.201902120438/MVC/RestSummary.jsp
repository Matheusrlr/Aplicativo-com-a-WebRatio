<!DOCTYPE html>
<html>
<head>
  <title>${wrProjectName} API</title>
  <base href="${wrBaseURI}/WRResources/swagger/"/>
  <link rel="icon" type="image/png" href="images/favicon-32x32.png" sizes="32x32" />
  <link rel="icon" type="image/png" href="images/favicon-16x16.png" sizes="16x16" />
  <link href='css/typography.css' media='screen' rel='stylesheet' type='text/css'/>
  <link href='css/reset.css' media='screen' rel='stylesheet' type='text/css'/>
  <link href='css/screen.css' media='screen' rel='stylesheet' type='text/css'/>
  <link href='css/reset.css' media='print' rel='stylesheet' type='text/css'/>
  <link href='css/print.css' media='print' rel='stylesheet' type='text/css'/>
  <script src='lib/jquery-1.8.0.min.js' type='text/javascript'></script>
  <script src='lib/jquery.slideto.min.js' type='text/javascript'></script>
  <script src='lib/jquery.wiggle.min.js' type='text/javascript'></script>
  <script src='lib/jquery.ba-bbq.min.js' type='text/javascript'></script>
  <script src='lib/handlebars-2.0.0.js' type='text/javascript'></script>
  <script src='lib/underscore-min.js' type='text/javascript'></script>
  <script src='lib/backbone-min.js' type='text/javascript'></script>
  <script src='swagger-ui.js' type='text/javascript'></script>
  <script src='lib/highlight.7.3.pack.js' type='text/javascript'></script>
  <script src='lib/marked.js' type='text/javascript'></script>
  <script src='lib/swagger-oauth.js' type='text/javascript'></script>

  <script type="text/javascript">
    $(function () {
      var url = window.location.search.match(/url=([^&]+)/);
      if (url && url.length > 1) {
        url = decodeURIComponent(url[1]);
      } else {
        url = "${wrBaseURI}/api-docs.do";
      }
      window.swaggerUi = new SwaggerUi({
        url: url,
        dom_id: "swagger-ui-container",
        supportedSubmitMethods: ['get', 'post', 'put', 'delete', 'patch'],
        onComplete: function(swaggerApi, swaggerUi){
          if(typeof initOAuth == "function") {
            initOAuth({
              clientId: "your-client-id",
              realm: "your-realms",
              appName: "your-app-name"
            });
          }

          $('pre code').each(function(i, e) {
            hljs.highlightBlock(e)
          });
        },
        onFailure: function(data) {
          log("Unable to Load SwaggerUI");
        },
        docExpansion: "none",
        apisSorter: "alpha",
        showRequestHeaders: false
      });
      window.swaggerUi.load();   
  });
  </script>
</head>

<body class="swagger-section">
<div id="message-bar" class="swagger-ui-wrap">&nbsp;</div>
<div class="swagger-ui-wrap"><ul id="resources"><li class="resource"><div class="heading"><h1 style="font-size:200%">${wrProjectName} API</h1></div></li></ul></div>
<div class="swagger-ui-wrap"><ul id="resources"><li class="resource"><div class="heading"><h4 style="font-size:150%;padding:2px">This is the Web representation of the ${wrProjectName} API.</h4></div></li></ul></div>
<div id="swagger-ui-container" class="swagger-ui-wrap"></div>
</body>
</html>
