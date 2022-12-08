#!/usr/bin/env ruby

# tree visibility
fin = File.open("day_08_input.txt","rt")

debug = true

rows = []
cols = []

rowno = 0
while iline = fin.gets
  rowno+=1
  line = iline.chomp
  rows << iline.split("").collect { |sheight| sheight.to_i }
  # puts "Row #{rowno} has #{line.length} cols"
end

puts "Have a forest of #{rowno} x #{rowno} trees"

fin.close

num_visible = 0
row = 0

dim = rows.length
max_factors = nil
max_score = 0
max_row = nil
max_col = nil

while row < dim
	if row == 0 || row == (dim-1)
    puts "Adding #{dim} for the #{row == 0 ? 'first' : 'last'} row"
    num_visible += dim
  else
    num_visible += 2 # the left and rightmost column is always visible
    puts "Row #{row} : Adding one for the left and one for the rightmost column - total is #{num_visible}"
    col = 1

    while col < (dim-1)
			height = rows[row][col]
      debug = height >= 8
      puts "-"*80 if debug
      puts "Checking Row #{row}, Col #{col} - Height is #{height}..." if debug
      visible = height > 0 # no point if the tree is 0 - can't be visible
      all_visible = true
      any_visible = false

      scorefacs = []

      score = 1
      if visible
        # ok: it needs to be visible in ANY direction, not all !
        # look left
        lcol = col

        # max factor
        scorefac = col
        visible = true
        while lcol > 0 && visible
          lcol-=1
          visible = rows[row][lcol] < height
          if !visible
            puts "Blocked to the left at col #{lcol} by tree of height #{rows[row][lcol]}" if debug
            all_visible = false
            scorefac = (col-lcol)
          end
        end

        score*=scorefac
        scorefacs << scorefac

        any_visible = true if visible

        # look right
        scorefac = (dim-col)-1
        rcol = col
        visible = true
				while rcol < (dim-1) && visible
          rcol+=1
					visible = rows[row][rcol] < height
					if !visible
						puts "Blocked to the right at col #{rcol} by tree of height #{rows[row][rcol]}" if debug
            all_visible = false
            scorefac = (rcol-col)
					end
        end
        any_visible = true if visible

        score*=scorefac
        scorefacs << scorefac

        # look up
        urow = row
        visible = true
        scorefac = row
        while urow > 0 && visible
          urow-=1
					visible = rows[urow][col] < height
					if !visible
						puts "Blocked upwards at row #{urow} by tree of height #{rows[urow][col]}" if debug
            all_visible = false
            scorefac = (row-urow)
          end
				end
        any_visible = true if visible
        score*=scorefac
        scorefacs << scorefac

        # look down
        drow = row
        visible = true
        scorefac = dim-row-1
				while drow < (dim-1) && visible
          drow+=1
					visible = rows[drow][col] < height
					if !visible
						puts "Blocked downwards at row #{drow} by tree of height #{rows[drow][col]}" if debug
            all_visible = false
            scorefac = (drow - row)
					end
        end
        score*=scorefac
        scorefacs << scorefac

        any_visible = true if visible

        if score > max_score
          max_score = score
          max_row = row
          max_col = col
          max_factors = scorefacs
        end

      end
			if any_visible
        puts "Tree '#{height}' at Row #{row}, Col #{col} is visible !" if debug
	      num_visible +=1
      end

      col+=1
    end
  end
  row+=1
end

puts "A total of #{num_visible} trees is visible from the outside."
puts "The max viewing score is #{max_score} at row #{max_row}, col #{max_col} - #{max_factors[0]} to the left, #{max_factors[1]} to the right, #{max_factors[2]} up and #{max_factors[3]} down."
