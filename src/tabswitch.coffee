$tabswitch = $("""<div id="tabswitch"><input type="text"><ul></ul></div>""")
$("body").append($tabswitch)

$tsInput = $("input[type=text]", $tabswitch)
$tsInput.on("keyup", (e) ->
    $active = $("li.active", $tsResults)
    switch e.keyCode
        when 13  # Enter
            selectedTabId = $("li.active", $tsResults).attr("id")
            if selectedTabId
                chrome.extension.sendMessage(
                    action: "activateTab"
                    tabId: selectedTabId
                    )
                $tabswitch.hide()
        when 27  # Escape
            $tabswitch.hide()
        when 38  # Up
            $prev = $active.prev("li")
            if $prev.size()
                $active.removeClass("active")
                $prev.addClass("active")
        when 40  # Down
            $next = $active.next("li")
            if $next.size()
                $active.removeClass("active")
                $next.addClass("active")
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
        when "toggle"
            $tabswitch.toggle()
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
            $("li:first-child", $tsResults).addClass("active")

    return)
