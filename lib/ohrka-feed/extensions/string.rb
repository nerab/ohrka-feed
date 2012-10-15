# -*- encoding: utf-8 -*-

class String
  #
  # http://snippets.dzone.com/posts/show/4578
  #
  def truncate(count = 30)
    if self.length >= count 
      shortened = self[0, count]
      splitted = shortened.split(/\s/)
      words = splitted.length
      splitted[0, words - 1].join(' ') + '…'
    else
      self
    end
  end
end