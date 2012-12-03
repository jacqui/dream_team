(function(root) {

  var Picker = (function() {

    function Picker(config) {
      this.sel = {
        player: ".player",
        player_container: "#pick-form",
        bucket_container: "#buckets"
      };
      this.endpoints = config.endpoints;
      this.players = this.initialize_players(config.players);
      this.buckets = this.initialize_buckets(config.buckets);
      this.render();
      this.bindings();
    };

    Picker.prototype.bindings = function() {
      $('.submit-buckets').bind('click', _.bind(this.submit, this));
    };

    Picker.prototype.initialize_players = function(data) {
      var picker = this;
      return _.map(data, function(player_data) {
        var player = new Player({
          picker: picker,
          data: player_data
        });
        $(picker.sel.player_container).append(player.el);
        return player;
      });
    };

    Picker.prototype.initialize_buckets = function(data) {
      var picker = this;
      return _.map(data, function(bucket_data) {
        var bucket = new Bucket({
          picker: picker,
          data: bucket_data
        });
        $(picker.sel.bucket_container).append(bucket.el);
        return bucket;
      });
    };

    Picker.prototype.submit = function() {
      if (this.is_valid()) {
        this.ajax({
          type: "POST",
          url: this.endpoints.update,
          data: this.serialize(),
          success: function() {alert('done!');},
        });
      } else {
        alert('invalid');
      }
    };

    Picker.prototype.serialize = function() {
      var buckets = _.map(this.buckets, function(bucket) {
        return bucket.serialize();
      });

      return {
        buckets: buckets
      };
    };

    Picker.prototype.is_valid = function() {
      return _.all(_.map(this.buckets, function(b) { return b.is_valid() }), _.identity);
    };

    Picker.prototype.display_players_for = function(bucket) {
      _.each(this.players, function(player) {
        if (player.data.position == bucket.data.pick_type) {
          player.show();
        } else {
          player.hide();
        }
      });
    };

    Picker.prototype.select_bucket = function(bucket) {
      this.selected_bucket = bucket;
      this.display_players_for(bucket);
    };

    Picker.prototype.ajax = function(opts) {
      opts.type  = opts.type  || 'GET';
      opts.error = opts.error || this.error;
      $.ajax(opts)
    };

    Picker.prototype.error = function(err) {
      alert(err);
    };

    Picker.prototype.render = function() {
      _.each(this.players, function(player) { player.render() });
      _.each(this.buckets, function(bucket) { bucket.render() });
    };

    Picker.prototype.get_player = function(id) {
      return _.detect(this.players, function(player) {
        return player.data.id == id;
      });
    };

    return Picker;

  })();

  window.Picker = Picker;

  var Player = (function() {

    function Player(config) {
      this.picker = config.picker;
      this.data = config.data;
      this.el = $("<li class='player nytint-hidden'></li>");
      this.template = JST['picks/player'];
      this.bindings();
    };

    Player.prototype.click = function() {
      this.picker.selected_bucket.select_player(this);
    };

    Player.prototype.select = function() {
      $(this.el).addClass('selected');
    };

    Player.prototype.unselect = function() {
      $(this.el).removeClass('selected');
    };

    Player.prototype.selected = function() {
      return (this.el).hasClass('selected');
    };

    Player.prototype.render = function() {
      this.el.html(this.template({
        player: this.data
      }));
    };

    Player.prototype.show = function() {
      this.el.removeClass('nytint-hidden');
    };

    Player.prototype.hide = function() {
      this.el.addClass('nytint-hidden');
    };

    Player.prototype.bindings = function() {
      $(this.el[0]).live('click', _.bind(this.click, this));
    };

    return Player;

  })();

  window.Player = Player;

  var Bucket = (function() {

    function Bucket(config) {
      this.picker = config.picker;
      this.data = config.data;
      this.el = $("<li class='bucket'></li>");
      this.template = JST['picks/bucket'];
      this.bindings();
    };

    Bucket.prototype.render = function() {
      this.el.html(this.template({
        bucket: this.data,
        picks: _.map(this.picks(), function(p) { return p.data })
      }));
      _.each(this.picks(), function(p) {
        p.select();
      });
    };

    Bucket.prototype.picks = function() {
      var picker = this.picker;
      return _.map(this.data.player_ids, function(player_id) {
        return picker.get_player(player_id);
      });
    };

    Bucket.prototype.select_player = function(player) {
      var picker = this.picker;
      this.data.player_ids.push(player.data.id);
      this.data.player_ids = _.uniq(this.data.player_ids);

      if (this.data.player_ids.length > this.data.count) {
        var rem = this.data.player_ids.splice(0, this.data.player_ids.length - this.data.count);
        _.each(rem, function(player_id) {
          var p = picker.get_player(player_id);
          p.unselect();
        });
      }
      this.render();
    };

    Bucket.prototype.is_valid = function() {
      if (!this.data.required)
        return true;
      return this.data.player_ids.length == this.data.count;
    };

    Bucket.prototype.select = function() {
      this.picker.select_bucket(this);
      $(this.picker.sel.bucket_container).find('.bucket.selected').removeClass('selected');
      this.el.addClass('selected');
    };

    Bucket.prototype.bindings = function() {
      this.el.bind('click', _.bind(this.select, this));
    };

    Bucket.prototype.serialize = function() {
      // this.data.player_ids = _.map(this.picks, function(p) { return p.data.id });
      return this.data;
    };

    return Bucket;

  })();

  window.Bucket = Bucket;

}).call(this);
