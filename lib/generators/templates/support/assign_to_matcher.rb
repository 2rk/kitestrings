RSpec::Matchers.define :assign_to do |first|
  match do |actual|
    @actual = actual

    firsts = first.to_s.split('.', 2)
    if firsts.length == 2
      @first = assigns(firsts.first).send(firsts.last)
    else
      @first = assigns(first)
    end

    case
      when @second.is_a?(Class)
        @first.is_a?(@second)
      when @second.is_a?(Array)
        expect(@first).to match_array(@second)
      else
        @first == @second
    end
  end

  chain :with_items do |*second|
    @second = Array(second)
  end

  chain :with do |second|
    @second = second
  end

  chain :with_kind_of do |second|
    @second = second
  end

  failure_message do
    build = ''
    if @second.is_a?(Array)
      build = "Expected to get IDs of #{@first.map(&:id)} but got #{@second.map(&:id)}\n"\
    end

    build + "#{@first.inspect}\n"\
      "  === BUT GOT ===\n"\
      "#{@second.inspect}\n"
  end
end
