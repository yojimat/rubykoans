# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutRegularExpressions < Neo::Koan
  def test_a_pattern_is_a_regular_expression
    assert_equal Regexp, /pattern/.class
  end

  def test_a_regexp_can_search_a_string_for_matching_content
    assert_equal 'match', "some matching content"[/match/]
  end

  def test_a_failed_match_returns_nil
    assert_equal nil, "some matching content"[/missing/]
  end

  # ------------------------------------------------------------------

  def test_question_mark_means_optional
    assert_equal 'ab', "abbcccddddeeeee"[/ab?/]
    assert_equal 'a', "abbcccddddeeeee"[/az?/]
  end

  def test_plus_means_one_or_more
    assert_equal 'bccc', "abbcccddddeeeee"[/bc+/]
  end

  def test_asterisk_means_zero_or_more
    assert_equal 'abb', "abbcccddddeeeee"[/ab*/]
    assert_equal 'a', "abbcccddddeeeee"[/az*/]
    assert_equal '', "abbcccddddeeeee"[/z*/]

    # THINK ABOUT IT:
    #
    # When would * fail to match?
    # * does not fail, the boundaries of a match is zero or all. * covers all the possible limits that can exist.
  end

  # THINK ABOUT IT:
  #
  # We say that the repetition operators above are "greedy."
  #
  # Why?
  # Because the expression captures all characters that matches it.
  # ------------------------------------------------------------------

  #In here we have two matches one 'a' and another 'az', the first that matches is the correct one.
  def test_the_left_most_match_wins
    assert_equal 'a', "abbccc az"[/az*/]
  end

  # ------------------------------------------------------------------

  def test_character_classes_give_options_for_a_character
    animals = ["cat", "bat", "rat", "zat"]
    assert_equal ["cat", "bat", "rat"], animals.select { |a| a[/[cbr]at/] }
  end

  def test_slash_d_is_a_shortcut_for_a_digit_character_class
    assert_equal '42', "the number is 42"[/[0123456789]+/]
    assert_equal '42', "the number is 42"[/\d+/]
  end

  def test_character_classes_can_include_ranges
    assert_equal '42', "the number is 42"[/[0-9]+/]
  end

  # The Whitespace characters are ' ', "\t", "\n" types.
  def test_slash_s_is_a_shortcut_for_a_whitespace_character_class
    assert_equal " \t\n", "space: \t\n"[/\s+/]
  end

  def test_slash_w_is_a_shortcut_for_a_word_character_class
    # NOTE:  This is more like how a programmer might define a word.
    # In here the first match is 'variable_1' so 42 does not come.
    assert_equal "variable_1", "variable_1 = 42"[/[a-zA-Z0-9_]+/]
    assert_equal "variable_1", "variable_1 = 42"[/\w+/]
  end

  def test_period_is_a_shortcut_for_any_non_newline_character
    assert_equal "abc", "abc\n123"[/a.+/]
  end

  def test_a_character_class_can_be_negated
    assert_equal "the number is ", "the number is 42"[/[^0-9]+/]
  end

  def test_shortcut_character_classes_are_negated_with_capitals
    # I missed the final space in here xD
    assert_equal "the number is ", "the number is 42"[/\D+/]
    assert_equal "space:", "space: \t\n"[/\S+/]
    # ... a programmer would most likely do
    # In here all the first match is " = ", '42' is not considered in the match.
    # It is a bit confusing if you think that the match already happen in "variable_1".
    # And because "variable_1" already matched "42" is not taken in account, but this is not true.
    # The match is really " = ". Mindblowing, it makes all sense when you understand this inversion of values.
    assert_equal " = ", "variable_1 = 42"[/[^a-zA-Z0-9_]+/]
    assert_equal " = ", "variable_1 = 42"[/\W+/]
  end

  # ------------------------------------------------------------------

  def test_slash_a_anchors_to_the_start_of_the_string
    assert_equal "start", "start end"[/\Astart/]
    assert_equal nil, "start end"[/\Aend/]
  end

  def test_slash_z_anchors_to_the_end_of_the_string
    assert_equal "end", "start end"[/end\z/]
    assert_equal nil, "start end"[/start\z/]
  end

  def test_caret_anchors_to_the_start_of_lines
    assert_equal '2', "num 42\n2 lines"[/^\d+/]
  end

  def test_dollar_sign_anchors_to_the_end_of_lines
    assert_equal '42', "2 lines\nnum 42"[/\d+$/]
  end

  def test_slash_b_anchors_to_a_word_boundary
    # In here is a bit confusing too, what boundary means? In this example the boundary on the start of the word is the correct one, not the two.
    # I did a test changing the location of \b to the end and it returned 'vine '?!
    # Another test withou the period or dot in the end return just vine, but what vine? Probabily the second one, because the position o \b matters.
    # /.vine\b/, just one more test, returned "ovine"?!
    # Now I know what period really represents, this expression started to make more sense now.
    # The period represents just one character. All makes sense now.
    assert_equal 'vines', "baovine vines"[/\bvine./]
  end

  # ------------------------------------------------------------------

  def test_parentheses_group_contents
    assert_equal 'hahaha', "ahahaha"[/(ha)+/]
  end

  # ------------------------------------------------------------------

  def test_parentheses_also_capture_matched_content_by_number
    assert_equal "Gray", "Gray, James"[/(\w+), (\w+)/, 1]
    assert_equal "James", "Gray, James"[/(\w+), (\w+)/, 2]
  end

  def test_variables_can_also_be_used_to_access_captures
    # Where does theses variables $1 and $2 comes from ? Are they the result of temporary variables that are saved in the memory of the last function call?
    assert_equal "Gray, James", "Name:  Gray, James"[/(\w+), (\w+)/]
    assert_equal "Gray", $1
    assert_equal "James", $2
  end

  # ------------------------------------------------------------------

  def test_a_vertical_pipe_means_or
    grays = /(James|Dana|Summer) Gray/
    assert_equal "James Gray", "James Gray"[grays]
    
    #In here, the number one represents just the match that are inside the parentheses.
    assert_equal "Summer", "Summer Gray"[grays, 1]
    assert_equal nil, "Jim Gray"[grays, 1]
  end

  # THINK ABOUT IT:
  #
  # Explain the difference between a character class ([...]) and alternation (|).
  # [...] its used to group character classes or one rule that matches all condition inside it, while alternation (|) are used to matches specific rules and just one rule.
  # ------------------------------------------------------------------

  def test_scan_is_like_find_all
    assert_equal ["one", "two", "three"], "one two-three".scan(/\w+/)
  end

  def test_sub_is_like_find_and_replace
    assert_equal "one t-three", "one two-three".sub(/(t\w*)/) { $1[0, 1] }
  end

  def test_gsub_is_like_find_and_replace_all
    assert_equal "one t-t", "one two-three".gsub(/(t\w*)/) { $1[0, 1] }
  end
end
