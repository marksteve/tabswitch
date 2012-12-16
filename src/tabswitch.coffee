$tabswitch = $("""<div id="tabswitch"><input type="text"><ul></ul></div>""")
$("body").append($tabswitch)

$tsInput = $("input[type=text]", $tabswitch)
$tsInput.on("keyup", (e) ->
    if e.keyCode == 13
        selectedTabId = $("li:first-child", $tsResults).attr("id")
        if selectedTabId
            chrome.extension.sendMessage(
                action: "activateTab"
                tabId: selectedTabId
                )
            $tabswitch.hide()
    else
        query = $tsInput.val()
        if query.length > 0
            chrome.extension.sendMessage(
                action: "queryTabs"
                query: query
                )
        else
            $tsResults.empty()
    return)

$tsResults = $("ul", $tabswitch)

chrome.extension.onMessage.addListener((msg) ->
    switch msg.action
        when "show"
            $tabswitch.show()
            $tsInput.select()

        when "queryResults"
            maxResults = 5
            results = 0
            $tsResults.empty()
            for tab in msg.results
                $result = $("""
                    <li id="#{tab.id}">
                        <h2>#{tab.title}</h2>
                        <span>#{tab.url}</span>
                    </li>
                    """)
                if tab.favIconUrl
                    $result.prepend($("""<img src="#{tab.favIconUrl}">"""))
                $tsResults.append($result)
                if ++results >= maxResults
                    break

    return)
