#!/usr/bin/env php
<?php
 /**
  * DESC
  * php version 8.1
  *
  * @category Cat
  * @package  Pack
  * @author   me <me@gmail.com>
  * @license  place.com BSD
  * @file     file 
  * @link     place.com
  */

  $today = new DateTime('now');
  $vacay = new DateTime('2024-06-01');

  $diff = $vacay->diff($today);
  echo $diff->format('%m months %d days %h hours %I minutes %s seconds')."\n";
?>
