module InvitesHelper

  Invite.state_machine(:status).events.map(&:name).each do |event|
    define_method("invite_#{event}_form") do |invite|
      render "invites/action_forms/invite_#{event}_form", invite: invite
    end
  end

  def invite_event_buttons(invite)
    content_tag_for :ul, invite, class: 'invite_events unstyled' do
      invite.status_events.collect do |event|
        concat(content_tag :li, send("invite_#{event}_form".to_sym, invite))
      end
    end
  end


end
