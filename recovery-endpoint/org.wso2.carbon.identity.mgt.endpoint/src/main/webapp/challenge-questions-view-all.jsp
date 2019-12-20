<%--
  ~ Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
  ~
  ~  WSO2 Inc. licenses this file to you under the Apache License,
  ~  Version 2.0 (the "License"); you may not use this file except
  ~  in compliance with the License.
  ~  You may obtain a copy of the License at
  ~
  ~    http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing,
  ~ software distributed under the License is distributed on an
  ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  ~ KIND, either express or implied.  See the License for the
  ~ specific language governing permissions and limitations
  ~ under the License.
  --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="org.owasp.encoder.Encode" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.IdentityManagementEndpointUtil" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.client.model.InitiateAllQuestionResponse" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.client.model.Question" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.client.model.RetryError" %>
<%@ page import="java.util.List" %>
<jsp:directive.include file="localize.jsp"/>

<%
    InitiateAllQuestionResponse initiateAllQuestionResponse = (InitiateAllQuestionResponse)
            session.getAttribute("initiateAllQuestionResponse");
    List<Question> challengeQuestions = initiateAllQuestionResponse.getQuestions();
    
    RetryError errorResponse = (RetryError) request.getAttribute("errorResponse");
    boolean reCaptchaEnabled = false;
    if (request.getAttribute("reCaptcha") != null && "TRUE".equalsIgnoreCase((String) request.getAttribute("reCaptcha"))) {
        reCaptchaEnabled = true;
    }
%>

<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "Wso2.identity.server")%>
    </title>
    
    <link rel="icon" href="images/favicon.png" type="image/x-icon"/>
    <link href="libs/bootstrap_3.3.5/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/Roboto.css" rel="stylesheet">
    <link href="css/custom-common.css" rel="stylesheet">
    <link href="css/joule-custom.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="https://use.fontawesome.com/releases/v5.11.2/css/all.css" integrity="sha384-KA6wR/X5RY4zFAHpv/CnoG2UW1uogYfdnP67Uv7eULvTveboZJg0qUpmJZb5VqzN" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.min.css">
    
    <!--[if lt IE 9]>
    <script src="js/html5shiv.min.js"></script>
    <script src="js/respond.min.js"></script>
    <![endif]-->
    <%
        if (reCaptchaEnabled) {
    %>
    <script src='<%=(request.getAttribute("reCaptchaAPI"))%>'></script>
    <%
        }
    %>
</head>

<body onload="setCookieByParam();">

<script>
    function setCookie() {
        var locale = document.getElementById("lnkChangeLanguage").getAttribute("lang");
        document.cookie = "lang=" + locale + "; path=/;";
        location.reload();
    }

    function setCookieByParam() {
        var urlParams = new URLSearchParams(window.location.search);
        var locale = urlParams.get("lang");
        document.cookie = "lang=" + locale + "; path=/;";
    }
</script>
<!-- header -->
<header class="header header-default">
    <div class="header__bar">
        <nav class="align-right horizontal nav nav--utility">
            <ul class="nav__menu nav__menu--social">
                <li class="icon-utility horizontal"><a href="https://twitter.com/CMA_Docs"><i class="icon-color fab fa-twitter" aria-hidden="true"></i><span class="webaim-hidden">on Twitter</span></a></li>
                <li class="icon-utility horizontal"><a href="https://www.linkedin.com/company/canadian-medical-association"><i class="icon-color fab fa-linkedin-in" aria-hidden="true"></i><span class="webaim-hidden">on LinkedIn</span></a></li>
                <li class="icon-utility horizontal"><a href="https://www.instagram.com/cma_docs/"><i class="icon-color fab fa-instagram" aria-hidden="true"></i><span class="webaim-hidden">on Instagram</span></a></li>
                <li class="icon-utility horizontal"><a href="https://www.facebook.com/CanadianMedicalAssociation"><i class="icon-color fab fa-facebook-f" aria-hidden="true"></i><span class="webaim-hidden">on Facebook</span></a></li>
                <li class="icon-utility horizontal"><a href="https://www.youtube.com/user/CanadianMedicalAssoc"><i class="icon-color fab fa-youtube" aria-hidden="true"></i><span class="webaim-hidden">on Youtube</span></a></li>
            </ul>
            <ul class="links nav__menu nav__menu--language">
                <% if (langCode != null && langCode.equals("fr")) { %>
                <li class="horizontal" onclick="setCookie()"><a id="lnkChangeLanguage" lang="en_GB" href="#" class=" icon-color language-link">English</a></li>
                <%} else { %>
                <li class="horizontal" onclick="setCookie()"><a id="lnkChangeLanguage" lang="fr_FR" href="#" class=" icon-color language-link">Français</a></li>
                <% } %>

            </ul>

        </nav>
    </div>
    <div class="container-fluid">
        <div class="pull-left brand float-remove-xs text-center-xs">
            <a href="https://www.cma.ca">
                <img src="images/logo-inverse.png" alt=<%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle,
                 "Wso2")%> title=<%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle,
                 "Wso2")%> class="logo">
                <%--                    <h1><em><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "Identity.server")%></em></h1>--%>
            </a>
        </div>
    </div>
</header>

<!-- page content -->
<div class="container-fluid body-wrapper">
    
    <div class="background-blue row">
        <!-- content -->
        <div class="col-xs-12 col-sm-10 col-md-8 col-lg-5 col-centered wr-login">
            <%
                if (errorResponse != null) {
            %>
            <div class="alert alert-danger" id="server-error-msg">
                <%=IdentityManagementEndpointUtil.i18nBase64(recoveryResourceBundle, errorResponse.getDescription())%>
            </div>
            <%
                }
            %>
            <div class="clearfix"></div>
            <div class="boarder-all ">
                
                <div class="padding-double">
                    <form method="post" action="processsecurityquestions.do" id="securityQuestionForm">
                        <%
                            int count = 0;
                            if (challengeQuestions != null) {
                                for (Question challengeQuestion : challengeQuestions) {
                        %>
                        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 form-group">
                            <label class="control-label"><%=Encode.forHtml(challengeQuestion.getQuestion())%>
                            </label>
                        </div>
                        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 form-group">
                            <input name="<%=Encode.forHtmlAttribute(challengeQuestion.getQuestionSetId())%>"
                                   type="text"
                                   class="form-control"
                                   tabindex="0" autocomplete="off" required/>
                        </div>
                        <%
                                }
                            }
                        %>
                        <%
                            if (reCaptchaEnabled) {
                        %>
                        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 form-group">
                            <div class="g-recaptcha"
                                 data-sitekey="<%=Encode.forHtmlContent((String)request.getAttribute("reCaptchaKey"))%>">
                            </div>
                        </div>
                        <%
                            }
                        %>
                        <div class="form-actions">
                            <button id="answerSubmit"
                                    class="wr-btn grey-bg col-xs-12 col-md-12 col-lg-12 uppercase font-extra-large"
                                    type="submit"><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "Submit")%>
                            </button>
                        </div>
                        <div class="clearfix"></div>
                    </form>
                </div>
            </div>
        </div>
        <!-- /content/body -->
    
    </div>
</div>
<!-- /content/body -->

</div>
</div>

<!-- footer -->
<footer class="footer">
    <div class="grid">
        <div class="col-sm-6">
            <p class="icon-utility"><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "copyright.canadian.medical.association")%></p>
        </div>
        <div class="col-sm-6">
            <nav class="nav nav--footer-utility pull-right">

                <ul data-region="utility_footer" class="nav__menu">
                    <% if (langCode != null && langCode.equals("fr")) { %>
                    <li class="horizontal">
                        <a href="https://www.cma.ca/fr/politiques-de-confidentialite-de-lamc-et-de-ses-filiales"><span class="icon-utility icon-color"><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "privacy")%></span></a>
                    </li>
                    <%} else { %>
                    <li class="horizontal">
                        <a href="https://www.cma.ca/privacy-policies-cma-and-its-subsidiaries"><span class="icon-utility icon-color"><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "privacy")%></span></a>
                    </li>
                    <% } %>

                    <% if (langCode != null && langCode.equals("fr")) { %>
                    <li class="horizontal">
                        <a href="https://www.cma.ca/fr/clauses-et-conditions-legales"><span class="icon-utility icon-color"><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "terms.and.conditions")%></span></a>
                    </li>
                    <%} else { %>
                    <li class="horizontal">
                        <a href="https://www.cma.ca/terms-and-conditions"><span class="icon-utility icon-color"><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "terms.and.conditions")%></span></a>
                    </li>
                    <% } %>

                    <% if (langCode != null && langCode.equals("fr")) { %>
                    <li class="horizontal">
                        <a href="https://www.cma.ca/fr/accessibilite"><span class="icon-utility icon-color"><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "accessibility")%></span></a>
                    </li>
                    <%} else { %>
                    <li class="horizontal">
                        <a href="https://www.cma.ca/accessibility"><span class="icon-utility icon-color"><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "accessibility")%></span></a>
                    </li>
                    <% } %>

                </ul>
            </nav>
        </div>
    </div>
<%--    <div class="container-fluid">--%>
<%--        <p><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "Wso2.identity.server")%> | &copy;--%>
<%--            <script>document.write(new Date().getFullYear());</script>--%>
<%--            <a href="<%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "business.homepage")%>" target="_blank"><i class="icon fw fw-wso2"></i> <%=--%>
<%--            IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "Inc")%>--%>
<%--            </a>.--%>
<%--            <%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "All.rights.reserved")%>--%>
<%--        </p>--%>
<%--    </div>--%>
</footer>
</body>
</html>
