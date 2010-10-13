<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta name="pageName" content="species"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!--    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery-ui-1.8.custom.min.js"></script>
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bie-theme/jquery-ui-1.8.custom.css" charset="utf-8">-->
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.cookie.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.highlight-3.js"></script>
    <script type="text/javascript">
        $(document).ready(function() {
            var facetLinksSize = $("ul#subnavlist li").size();
            if (facetLinksSize == 0) {
                // Hide an empty facet link list
                $("#facetBar > h4").hide();
                $("#facetBar #navlist").hide();
            }
            
            // listeners for sort widgets
            $("select#sort").change(function() {
                var val = $("option:selected", this).val();
                reloadWithParam('sort',val);
            });
            $("select#dir").change(function() {
                var val = $("option:selected", this).val();
                reloadWithParam('dir',val);
            });
            $("select#per-page").change(function() {
                var val = $("option:selected", this).val();
                reloadWithParam('pageSize',val);
            });
            // highlight search terms in results
            //$('.results p').highlight('${queryJsEscaped}');
            var words = '${fn:trim(queryJsEscaped)}'; // remove leading + trailing white space
            $.each(words.split(" "), function(idx, val) { $('.results p').highlight(val); });
        });

        // jQuery getQueryParam Plugin 1.0.0 (20100429)
        // By John Terenzio | http://plugins.jquery.com/project/getqueryparam | MIT License
        // Adapted by Nick dos Remedios to handle multiple params with same name - return a list
        (function ($) {
            // jQuery method, this will work like PHP's $_GET[]
            $.getQueryParam = function (param) {
                // get the pairs of params fist
                var pairs = location.search.substring(1).split('&');
                var values = [];
                // now iterate each pair
                for (var i = 0; i < pairs.length; i++) {
                    var params = pairs[i].split('=');
                    if (params[0] == param) {
                        // if the param doesn't have a value, like ?photos&videos, then return an empty srting
                        //return params[1] || '';
                        values.push(params[1]);
                    }
                }

                if (values.length > 0) {
                    return values;
                } else {
                    //otherwise return undefined to signify that the param does not exist
                    return undefined;
                }

            };
        })(jQuery);

        function removeFacet(facet) {
            var q = $.getQueryParam('q'); //$.query.get('q')[0];
            var fqList = $.getQueryParam('fq'); //$.query.get('fq');
            var paramList = [];
            if (q != null) {
                paramList.push("q=" + q);
            }
            //alert("this.facet = "+facet+"; fqList = "+fqList.join('|'));

            if (fqList instanceof Array) {
                //alert("fqList is an array");
                for (var i in fqList) {
                    //alert("i == "+i+"| fq = "+fqList[i]);
                    if (decodeURI(fqList[i]) == facet) {
                        //alert("removing fq: "+fqList[i]);
                        fqList.splice(fqList.indexOf(fqList[i]),1);
                    }
                }
            } else {
                //alert("fqList is NOT an array");
                if (decodeURI(fqList) == facet) {
                    fqList = null;
                }
            }
            //alert("(post) fqList = "+fqList.join('|'));
            if (fqList != null) {
                paramList.push("fq=" + fqList.join("&fq="));
            }

            window.location.replace(window.location.pathname + '?' + paramList.join('&'));
        }

        /**
         * Catch sort drop-down and build GET URL manually
         */
        function reloadWithParam(paramName, paramValue) {
            var paramList = [];
            var q = $.getQueryParam('q'); //$.query.get('q')[0];
            var fqList = $.getQueryParam('fq'); //$.query.get('fq');
            var sort = $.getQueryParam('sort');
            var dir = $.getQueryParam('dir');
            // add query param
            if (q != null) {
                paramList.push("q=" + q);
            }
            // add filter query param
            if (fqList != null) {
                paramList.push("fq=" + fqList.join("&fq="));
            }
            // add sort param if already set
            if (paramName != 'sort' && sort != null) {
                paramList.push('sort' + "=" + sort);
            }

            if (paramName != null && paramValue != null) {
                paramList.push(paramName + "=" +paramValue);
            }

            //alert("params = "+paramList.join("&"));
            //alert("url = "+window.location.pathname);
            window.location.replace(window.location.pathname + '?' + paramList.join('&'));
        }

    </script>
    <style type="text/css" media="screen">
        .highlight { font-weight: bold; }
        div.results span .resultsLabel {
            color: #555;
            font-weight: normal;
        }
        div.results span.highlight {
            display: inline;
        }
        #facets {
            margin-top:-1px;
        }
        #facets > h3 {
            border-bottom: 1px solid #E8EACE;
            font-size: 1em;
            font-weight: bold;
            line-height: 2em;
        }
        #facets  h3 {
            padding: 3px 4px;
        }
        #subnavlist li {
            text-transform: capitalize;
        }
        #facets #accordion { display: block; }
        div.results span.commonNameSummary {
            display: inline;
            color: #222;
        }
    </style>
    <title>${query} | Search | Atlas of Living Australia</title>
    <link rel="stylesheet" href="http://test.ala.org.au/wp-content/themes/ala/css/bie.css" type="text/css" media="screen" charset="utf-8"/>
<!--    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/screen.css" type="text/css" media="screen" charset="utf-8"/>-->
</head>
<body>
<c:if test="${empty searchResults.results}">
    <div  id="searchResults"><p>Search for <span style="font-weight: bold"><c:out value="${query}"/></span> did not match any documents</p></div>
</c:if>
<c:if test="${not empty searchResults.results}">
    <c:set var="pageTitle">
        <c:if test="${not empty title}">${title}</c:if>
        <c:if test="${empty title}">Search Results</c:if>
    </c:set>
    <div id="header">
        <div id="breadcrumb">
            <a href="http://test.ala.org.au">Home</a>
            <a href="http://test.ala.org.au/explore/">Explore</a>
            <span class="current">Search the Atlas</span>
        </div>
        <div class="astrisk" style="display:none">
            <h1>Search Results</h1>
            <p>Looking for specimen or occurrence data? <a href="http://biocache.ala.org.au/occurrences/search?q=${param['q']}">Search for occurrence records</a></p>
        </div>
    </div><!--close header-->
    <div id="refine-results" class="section no-margin-top">
        <h2>Refine results</h2>
        <h3><strong><fmt:formatNumber value="${searchResults.totalRecords}" pattern="#,###,###"/></strong> results
            returned for <strong><a href="?q=${queryJsEscaped}">${queryJsEscaped}</a></strong></h3>
    </div>
    <div id="searchResults">
        <div id="facets">
            <c:if test="${not empty TAXON or not empty REGION or not empty INSTITUTION or not empty COLLECTION or not empty DATAPROVIDER or not empty DATASET}">
                <c:set var="taxon" scope="session"><c:out value="${TAXON}"/></c:set>
                <c:set var="region" scope="session"><c:out value="${REGION}"/></c:set>
                <c:set var="institution" scope="session"><c:out value="${INSTITUTION}"/></c:set>
                <c:set var="collection" scope="session"><c:out value="${COLLECTION}"/></c:set>
                <c:set var="dataprovider" scope="session"><c:out value="${DATAPROVIDER}"/></c:set>
                <c:set var="dataset" scope="session"><c:out value="${DATASET}"/></c:set>
            </c:if>
            <div id="accordion">
                <c:if test="${not empty query}">
                    <c:set var="queryParam">q=<c:out value="${query}" escapeXml="true"/><c:if test="${not empty param.fq}">&fq=${fn:join(paramValues.fq, "&fq=")}</c:if></c:set>
                </c:if>
                <c:forEach var="facetResult" items="${searchResults.facetResults}">
                    <c:if test="${!fn:containsIgnoreCase(facetQuery, facetResult.fieldResult[0].label) && !fn:containsIgnoreCase(facetResult.fieldName, 'idxtype1')}">
                        <h3><span class="FieldName"><fmt:message key="facet.${facetResult.fieldName}"/></span></h3>
                        <div id="subnavlist">
                            <ul>
                                <c:set var="lastElement" value="${facetResult.fieldResult[fn:length(facetResult.fieldResult)-1]}"/>
                                <c:if test="${lastElement.label eq 'before'}">
                                    <li><c:set var="firstYear" value="${fn:substring(facetResult.fieldResult[0].label, 0, 4)}"/>
                                        <a href="?${queryParam}&fq=${facetResult.fieldName}:[* TO ${facetResult.fieldResult[0].label}]">Before ${firstYear}</a>
                                        (<fmt:formatNumber value="${lastElement.count}" pattern="#,###,###"/>)
                                    </li>
                                </c:if>
                                <c:if test="${fn:containsIgnoreCase(facetResult.fieldName, 'idxtype') && not empty wordpress && wordpress > 0 && empty param.fq}">
                                    <li><a href="http://test.ala.org.au/search/?s=${param['q']}">Site pages</a> (${wordpress})</li>
                                </c:if>
                                <c:forEach var="fieldResult" items="${facetResult.fieldResult}" varStatus="vs">
                                    <c:set var="dateRangeTo"><c:choose><c:when test="${vs.last}">*</c:when><c:otherwise>${facetResult.fieldResult[vs.count].label}</c:otherwise></c:choose></c:set>
                                    <c:choose>
                                        <c:when test="${fn:containsIgnoreCase(facetResult.fieldName, 'occurrence_date') && fn:endsWith(fieldResult.label, 'Z')}">
                                            <li><c:set var="startYear" value="${fn:substring(fieldResult.label, 0, 4)}"/>
                                                <a href="?${queryParam}&fq=${facetResult.fieldName}:[${fieldResult.label} TO ${dateRangeTo}]">${startYear} - ${startYear + 10}</a>
                                                (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)</li>
                                        </c:when>
                                        <c:when test="${fn:endsWith(fieldResult.label, 'before')}"><%-- skip --%></c:when>
                                       <c:when test="${not empty facetMap[facetResult.fieldName] && fieldResult.label == facetMap[facetResult.fieldName]}">
                                            <li><a href="#" onClick="removeFacet('${facetResult.fieldName}:${fieldResult.label}'); return false;" class="facetCancelLink">&lt; Any <fmt:message key="facet.${facetResult.fieldName}"/></a><br/>
                                            <b><fmt:message key="${fieldResult.label}"/></b></li>
                                        </c:when>
                                        <c:otherwise>
                                            <li><a href="?${queryParam}&fq=${facetResult.fieldName}:${fieldResult.label}"><fmt:message key="${fieldResult.label}"/></a>
                                            (<fmt:formatNumber value="${fieldResult.count}" pattern="#,###,###"/>)
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div><!--facets-->
        <div class="solrResults">
            <div id="dropdowns">
                <div id="resultsStats">
                    <label for="per-page">Results per page</label>
                    <select id="per-page" name="per-page">
                        <option value="10" <c:if test="${param.pageSize eq '10'}">selected</c:if>>10</option>
                        <option value="20" <c:if test="${param.pageSize eq '20'}">selected</c:if>>20</option>
                        <option value="50" <c:if test="${param.pageSize eq '50'}">selected</c:if>>50</option>
                        <option value="100" <c:if test="${param.pageSize eq '100'}">selected</c:if>>100</option>
                    </select>
                </div>
                <div id="sortWidget">
                    Sort by
                    <select id="sort" name="sort">
                        <option value="score" <c:if test="${param.sort eq 'score'}">selected</c:if>>best match</option>
                        <option value="scientificNameRaw" <c:if test="${param.sort eq 'scientificNameRaw'}">selected</c:if>>scientific name</option>
                        <!--                            <option value="rank">rank</option>-->
                        <option value="commonNameSort" <c:if test="${param.sort eq 'commonNameSort'}">selected</c:if>>common name</option>
                        <option value="rank" <c:if test="${param.sort eq 'rank'}">selected</c:if>>taxon rank</option>
                    </select>
                    Sort order
                    <select id="dir" name="dir">
                        <option value="asc" <c:if test="${param.dir eq 'asc'}">selected</c:if>>normal</option>
                        <option value="desc" <c:if test="${param.dir eq 'desc'}">selected</c:if>>reverse</option>
                    </select>

                    <input type="hidden" value="${pageTitle}" name="title"/>

                </div><!--sortWidget-->
            </div><!--drop downs-->
            <div class="results">
                <c:forEach var="result" items="${searchResults.results}">
                    <c:set var="sectionText">
                        <c:if test="${empty facetMap.idxtype}">
                            <span><b>Section:</b> <fmt:message key="idxType.${result.idxType}"/></span>
                        </c:if>
                    </c:set>
                    <c:choose>
                        <c:when test="${result.class.name == 'org.ala.dto.SearchTaxonConceptDTO'}">
                            <h4> 
                                <c:if test="${not empty result.thumbnail}"><a href="${pageContext.request.contextPath}/species/${result.guid}" class="occurrenceLink"><img class="alignright" src="${result.thumbnail}" width="85" height="85" alt="species image thumbnail"/></a></c:if>
                                <c:if test="${empty result.thumbnail}"><div class="alignright" style="width:85px; height:40px;"></div></c:if>
                                <span style="text-transform: capitalize; display: inline;">${result.rank}</span>:
                                <a href="${pageContext.request.contextPath}/species/${result.guid}" class="occurrenceLink"><alatag:formatSciName rankId="${result.rankId}" name="${result.name}" acceptedName="${result.acceptedConceptName}"/> ${result.author}</a>
                                <c:if test="${not empty result.commonNameSingle}"><span class="commonNameSummary">&nbsp;&ndash;&nbsp; ${result.commonNameSingle}</span></c:if>
                            </h4>
                            <p>
                                <c:if test="${not empty result.commonNameSingle && result.commonNameSingle != result.commonName}">
                                    <span>${fn:substring(result.commonName, 0, 220)}<c:if test="${fn:length(result.commonName) > 220}">...</c:if></span>
                                </c:if>
                                <c:if test="${false && not empty result.highlight}">
                                    <span><b>...</b> ${result.highlight} <b>...</b></span>
                                </c:if>
                                <c:if test="${not empty result.kingdom}">
                                    <span><strong class="resultsLabel">Kingdom</strong>: ${result.kingdom}</span>
                                </c:if>
                                <!-- ${sectionText} -->
                            </p>
                        </c:when>
                        <c:when test="${result.class.name == 'org.ala.dto.SearchRegionDTO'}">
                            <h4><fmt:message key="idxType.${result.idxType}"/>:
                                <a href="${pageContext.request.contextPath}/regions/${result.guid}">${result.name}</a></h4>
                            <p>
                                <span>Region type: ${result.regionTypeName}</span>
                                <!-- ${sectionText} -->
                            </p>
                        </c:when>
                        <c:when test="${result.class.name == 'org.ala.dto.SearchCollectionDTO'}">
                            <h4><fmt:message key="idxType.${result.idxType}"/>:
                                <a href="${result.guid}">${result.name}</a></h4>
                            <p>
                                <span>${result.institutionName}</span>
                                <!-- ${sectionText} -->
                            </p>
                        </c:when>
                        <c:when test="${result.class.name == 'org.ala.dto.SearchInstitutionDTO'}">
                            <h4><fmt:message key="idxType.${result.idxType}"/>:
                                <a href="${result.guid}">${result.name}</a></h4>
                            <p>
                                <span>${result.acronym}</span>
                                <!-- ${sectionText} -->
                            </p>
                        </c:when>
                        <c:when test="${result.class.name == 'org.ala.dto.SearchDataProviderDTO'}">
                            <h4><fmt:message key="idxType.${result.idxType}"/>:
                                <a href="${result.guid}">${result.name}</a></h4>
                            <p>
                                <span>${result.description}</span>
                                <!-- ${sectionText} -->
                            </p>
                        </c:when>
                        <c:otherwise>
                            <h4><fmt:message key="idxType.${result.idxType}"/>: <a href="${result.guid}">${result.name}</a></h4>
                            <p><!-- ${sectionText} --></p>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </div><!--close results-->
            <div id="searchNavBar">
                <alatag:searchNavigationLinks totalRecords="${searchResults.totalRecords}" startIndex="${searchResults.startIndex}"
                     lastPage="${lastPage}" pageSize="${searchResults.pageSize}"/>
            </div>
        </div><!--solrResults-->
    </div>
</c:if>
</body>
</html>
