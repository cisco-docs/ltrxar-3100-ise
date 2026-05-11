*** Settings ***
Library   pabot.PabotLib
Library   RequestsLibrary
Library   JSONLibrary
Library   Collections
Library   OperatingSystem

*** Keywords ***
Login ISE
    ${auth}=   Create List   %{ISE_USERNAME}   %{ISE_PASSWORD}
    ${ise_insecure}=   Get Environment Variable   ISE_INSECURE   True
    ${verify}=   Set Variable If   '${ise_insecure}' == 'True' or '${ise_insecure}' == 'true'   False   True
    Create Session   ISE_Session   %{ISE_URL}   auth=${auth}   verify=${verify}   headers={"Accept": "application/json", "Content-Type": "application/json"}

Should Be Equal Value Json String
    [Arguments]   ${json}   ${json_path}   ${value}=${EMPTY}
    ${r_value}=   Get Value From Json   ${json}   ${json_path}
    Run Keyword If   "${value}" != "${EMPTY}"   Should Be Equal As Strings   ${r_value}[0]   ${value}

Should Be Equal Value Json List
    [Arguments]   ${json}   ${json_path}   ${value}=${None}
    ${r_value}=   Get Value From Json   ${json}   ${json_path}
    Run Keyword If   "${value}" != "${None}"   Lists Should Be Equal   ${r_value}[0]   ${value}   ignore_order=True

Get All Pages
    [Arguments]   ${session}   ${url}   ${merged_dict}=${None}
    ${r}=   GET On Session   ${session}   ${url}
    Log   Response Status Code: ${r.status_code}
    ${data}=   Set Variable   ${r.json()}
    ${search_result}=   Get From Dictionary   ${data}   SearchResult
    ${merged_dict}=   Merge SearchResult   ${data}   ${merged_dict}
    ${next_page}=   Run Keyword If   'nextPage' in ${search_result}   Get From Dictionary   ${search_result}   nextPage   ELSE   Create Dictionary
    ${next_page_href}=   Run Keyword If   'href' in ${next_page}   Get From Dictionary   ${next_page}   href   ELSE   Set Variable   ${None}

    ${merged_dict}=   Run Keyword If   '${next_page_href}' != '${None}'   Get All Pages   ${session}   ${next_page_href}   ${merged_dict}   ELSE   Set Variable   ${merged_dict}
    RETURN   ${merged_dict}

Merge SearchResult
    [Arguments]   ${dict1}   ${dict2}
    ${resources1}=   Get From Dictionary   ${dict1['SearchResult']}   resources
    ${resources2}=   Run Keyword If   ${dict2} != ${None}   Get From Dictionary   ${dict2['SearchResult']}   resources   ELSE   Create List
    Append To List   ${resources1}   @{resources2}
    ${searchResult}=   Get From Dictionary   ${dict1}   SearchResult
    Set To Dictionary   ${searchResult}   resources   ${resources1}
    Set To Dictionary   ${dict1}   SearchResult   ${searchResult}
    RETURN   ${dict1}