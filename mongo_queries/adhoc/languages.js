load('/usr/local/src/lodash/lodash.min.js');

var language_count = [];

var languages = db.users.distinct( 'languages' );

_.forEach(languages, function(language) {
  var helpers_count = db.users.count( { languages: { $in: [ language ] }, role:"helper" } );
  var blind_count = db.users.count( { languages: { $in: [ language ] }, role:"blind" } );

  cnt = { helper_count:helpers_count, language:language, blind_count:blind_count};
  language_count.push(cnt);
});

_.sortBy(language_count, function(count) { return count.helper_count });

