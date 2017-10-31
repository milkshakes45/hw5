# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  if not page.body.index(e1) < page.body.index(e2)
    assert false
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  if uncheck == "un"
    rating_list.split(', ').each do |x|
      step %{I uncheck "ratings_#{x}"}
    end
  else
    rating_list.split(', ').each do |x|
      step %{I check "ratings_#{x}"}
    end
  end
end

Then /I should see all the movies/ do
  page.assert_selector('#movies tbody', :count == Movie.count)
end
