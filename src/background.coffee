chrome.browserAction.onClicked.addListener((tab) ->
    chrome.tabs.sendMessage(tab.id, action: "show")
    return)

chrome.extension.onMessage.addListener((msg, sender, sendResponse) ->
    console.log(msg)
    switch msg.action
        when "queryTabs"
            chrome.tabs.query(title: "*#{msg.query}*", (tabs) ->
                queryInfo =
                    action: "queryResults"
                    results: tabs
                chrome.tabs.sendMessage(sender.tab.id, queryInfo)
                return)
        when "activateTab"
            chrome.tabs.update(parseInt(msg.tabId, 10), active: true, (tab) ->
                return)
    return)
