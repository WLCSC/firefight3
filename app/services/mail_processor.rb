class MailProcessor
  class << self
    def call *args
      mail = args.pop
      from = mail.from.first.split('@')[0]
      if u = User.find(from)
        if md = mail.subject.match(/[Rr][Ee]: Ticket #(\d+)/)
          frag = mail.parts[0].body.split(/On .+@wl.k12.in.us> wrote:/)[0]
        else
          topic = Topic.find(APP_CONFIG['mail_queue'])
          t = Ticket.new topic: topic, status: 20, comment: mail.parts[0].body, targetable: TargetableFinder.call('User', from), submitter_sid: from
          if t.save
            t.notify_all
          end
        end
      else
        return false
      end
    end
  end
end
