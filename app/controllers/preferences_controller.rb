class PreferencesController < NSWindowController
  extend IB

  outlet :u_vote_shortcut
  outlet :d_vote_shortcut

  def init
    initWithWindowNibName('Preferences').tap do |pc|
    end
  end

  def awakeFromNib
    u_vote_shortcut_var = "GlobalShortcutVoteU"
    d_vote_shortcut_var = "GlobalShortcutVoteD"

    self.u_vote_shortcut.associatedUserDefaultsKey = u_vote_shortcut_var
    self.d_vote_shortcut.associatedUserDefaultsKey = d_vote_shortcut_var

    MASShortcut.registerGlobalShortcutWithUserDefaultsKey(
      u_vote_shortcut_var, handler: lambda do
        VoteHandler.register(true)
      end
    )

    MASShortcut.registerGlobalShortcutWithUserDefaultsKey(
      d_vote_shortcut_var, handler: lambda do
        VoteHandler.register(false)
      end
    )
  end

  def toggle_always_show_votes(button)
    App.notification_center.post(JB_TOGGLE_VOTE_SLIDER, nil, {state:button.state})
  end

end