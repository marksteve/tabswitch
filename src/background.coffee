chrome.browserAction.onClicked.addListener((tab) ->
    chrome.tabs.sendMessage(tab.id, action: "toggle")
    return)

chrome.extension.onMessage.addListener((msg, sender, sendResponse) ->
    switch msg.action
        when "queryTabs"
            chrome.tabs.query({}, (tabs) ->
                results = []
                for tab in tabs
                    pat = new RegExp(msg.query, 'i')
                    if pat.test(tab.url) or pat.test(tab.title)
                        results.push(tab)
                queryInfo =
                    action: "queryResults"
                    results: results
                chrome.tabs.sendMessage(sender.tab.id, queryInfo)
                return)
        when "activateTab"
            chrome.tabs.update(parseInt(msg.tabId, 10), active: true, (tab) ->
                return)
    return)
