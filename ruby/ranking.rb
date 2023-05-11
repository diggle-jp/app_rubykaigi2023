require 'js'

$rank = [
  ['[DIGGLE] zakky', 15.103],
  ['[DIGGLE] umeda', 32.952],
  ['[DIGGLE] t_ito', 16.933],
  ['[DIGGLE] niku', 21.345],
  ['[DIGGLE] taisei', 16.119],
  ['[DIGGLE] tushar', 52.651],
  ['[DIGGLE] kato', 23.464],
].sort{|a, b| a.last <=> b.last}.freeze
# $JS_NULL = JS.eval("return null")
$document = JS.global[:document]

$prev_btn = $document.getElementById('prev')
$next_btn = $document.getElementById('next')

class Ranking
  attr_reader :page

  PER_PAGE = 10.freeze
  def initialize
    @page = 0
  end

  def create_tr(child_node, no, name, time)
    tr = $document.createElement('tr')
    [no, name, time].each do |label|
      td = $document.createElement(child_node)
      td[:innerHTML] = label.to_s
      tr.appendChild(td)
    end
    tr
  end

  def rank(page)
    arr = $rank.slice(page * PER_PAGE, PER_PAGE)
    arr.concat([['-', '-']] * (PER_PAGE - arr.length))
  end

  def render(offset)
    @page += offset
    tbody = $document.querySelector('#ranking tbody')
    until (target = tbody[:firstChild]) == JS::Null do
      tbody.removeChild(target)
    end

    p rank(page)
    rank(page).each.with_index do |rank, idx|
      tbody.appendChild(create_tr('td', (page * PER_PAGE) + idx + 1, *rank))
    end

    $prev_btn[:disabled] = false
    $next_btn[:disabled] = false
    $prev_btn[:disabled] = true if page.zero?
    $next_btn[:disabled] = true if (page + 1) * PER_PAGE > $rank.size
  end
end

$ranking = Ranking.new
$ranking.render(0)
$prev_btn.addEventListener('click', ->(e) { $ranking.render(-1) }, false)
$next_btn.addEventListener('click', ->(e) { $ranking.render(1) }, false)