class SidFinder
  def self.call *args
    begin
      given = args.delete_at(0)
      if given.is_a? ActiveLdap::DistinguishedName
        if u = User.find(given)
          return u
        else
          if g = Group.find(given)
            return g
          else
            nil
          end
        end
      else
        #Rails.logger.info { given }
        if given.match /G\/(.+)/
          if g = Group.find(:first, $1)
            return g
          else
            nil
          end
        else
          if u = User.find(:first, given)
            return u
          else
            if g = Group.find(:first, given)
              return g
            else
              nil
            end
          end
        end
      end
    rescue ActiveLdap::EntryNotFound, TypeError
      nil
    end
  end
end
