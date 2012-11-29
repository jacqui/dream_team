(function() {
  $(".candidates .player").live('click', function(ev) {
    var form = $("#new-pick");
    var player = $(ev.target).closest('.player');
    var id = player.data('player-id');

    form.find(".pick_id").val(id);
    player.toggleClass('selected');
  });
}).call(this);
