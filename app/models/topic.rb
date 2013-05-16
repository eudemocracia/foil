class Topic < ActiveRecord::Base
  belongs_to :space
  belongs_to :superthread, class_name: 'Topic'
  has_many   :subthreads, class_name: 'Topic'
  has_many   :messages

  validates  :title, presence: true

  def self.assimilate space, thread_title
    thread = space.threads
    subthread = self

    thread_title.split( ">" ).each do | subtitle |
      subtitle.strip!
      subthread = thread.find_by_title subtitle

      if subthread == nil
        subthread = thread.create title: subtitle
      end

      thread = subthread.subthreads
    end

    return subthread
  end

  def full_title
    title = Array.new
    thread = self

    while thread
      title.prepend thread.title
      thread = thread.superthread
    end

    return title
  end
end
