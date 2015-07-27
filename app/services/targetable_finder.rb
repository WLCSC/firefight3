class TargetableFinder
  def self.call *args
    puts args.inspect
    if args.count >= 2
      id = args.pop
      t = args.pop.try(:downcase)
      puts "***#{t} - #{id}"
      case t
      when 'user'
        User.find(:first, id)
      when 'group'
        Group.find(:first, id)
      when 'room'
        if id =~ /\//
          id = id.split('/')[1]
        end
        puts "***#{t} - #{id}"
        Room.where('name ILIKE ?', id).first
      when 'building'
        Building.where('name ILIKE ?', id).first
      when 'asset'
        Asset.where('tag ILIKE ?', id).first
      when 'service'
        Service.where('name ILIKE ?', id).first
      when 'topic'
        Topic.find(id)
      when 'consumable'
        Consumable.where('short ILIKE ?', id).first
      else
        nil
      end
    else
      nil
    end
  end
end
