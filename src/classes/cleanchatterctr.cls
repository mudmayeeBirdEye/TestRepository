public with sharing class cleanchatterctr {

public cleanchatterctr () {}
    /*
    public PageReference save() { 
        List<UserFeed> accountFeeds = [Select ParentId, Id, FeedPost.ParentId, FeedPostId From UserFeed];
        if(accountFeeds != null) {
            delete accountFeeds;
        }
        AccountFeed[] feed = [Select Id from AccountFeed limit 10000];
        delete feed;
        return null;     
    }
    */
}