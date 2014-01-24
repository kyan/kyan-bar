class PreferencesController < NSWindowController
  extend IB

  outlet :u_vote_shortcut
  outlet :d_vote_shortcut

  def init
    initWithWindowNibName('Preferences').tap do |pc|
    end
  end

  def awakeFromNib
    self.u_vote_shortcut.associatedUserDefaultsKey = U_VOTE_SHORTCUT_VAR
    self.d_vote_shortcut.associatedUserDefaultsKey = D_VOTE_SHORTCUT_VAR
  end

  def toggle_always_show_votes(button)
    App.notification_center.post(JB_TOGGLE_VOTE_SLIDER, nil, {state:button.state})
  end

end