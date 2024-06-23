/* Mastodon embed timeline v4.4.2 */
/* More info at: */
/* https://gitlab.com/idotj/mastodon-embed-timeline */

/* Main Javascript imported via CDN (check Pen JS settings) */

const myTimeline = new MastodonTimeline.Init({
  instanceUrl: "https://mastodon.scot",
  timelineType: "profile",
  userId: "112570601427812818",
  profileName: "@spli",
});

