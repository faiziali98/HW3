Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  assert page.body.to_s.index(e1)< page.body.to_s.index(e2)
end

Then /I should (not )?see movies rated: (.*)/ do |negation,list|
  ratings = list.split(',')
  ratings = Movie.all_ratings - ratings if negation
  nofmovies = (Movie.where("rating IN (?)", ratings).size)
  assert nofmovies == (page.all('table#movies tr').count-1)
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(",").each do | rating |
    rating = "ratings_" + rating
    if uncheck
      uncheck(rating)
    else
      check(rating)
    end
  end
end

Then /I should see all the movies/ do
  assert (Movie.all.count) == (page.all('table#movies tr').count-1)
end
