
# CHANGELOG.md


### rufus-scheduler 3.8.2 - released 2022-07-12

* Prevent error in shutdown when @thread is current Thread, gh-337
* Rescue errors on the scheduling thread, gh-335


### rufus-scheduler 3.8.1 - released 2022-01-11

* Suppress warning about @resume_discard_past
* Suppress warning about unused variable, solackerman gh-332


### rufus-scheduler 3.8.0 - released 2021-07-14

* Add #source_location to Job, gh-322


### rufus-scheduler 3.7.0 - released 2020-12-31

* Implement Job name:/n: #name and #name=, gh-309
* Add Job #has_key?, #value, and #entries
* Add #locals access to Job
* Implement Scheduler#around_trigger, @jjb, gh-310
* Accept max_worker_threads: for max_work_threads:
* Clean up Scheduler#shutdwon, thanks @itsaphel and @jjb, gh-304, gh-315

* f59df40 Bring in discard_past: for every jobs, gh-290
* 7613277 Introduce :discard_past = false for cron, gh-305


### rufus-scheduler 3.6.0 - released 2019-04-22

* Let Scheduler#cron fail if the cron string is invalid, gh-289
* Implement Job#next_times(count) for cron, every, and interval jobs
* Implement Job#next_times(count) for at and in jobs
* Stop fooling around and stick to https://semver.org


### rufus-scheduler 3.5.2 - released 2018-08-01

* Use Fugit::Cron#rough_frequency
* Improve Job#check_frequency performance, gh-276, @drcapulet


### rufus-scheduler 3.5.1 - released 2018-07-20

* Upgrade fugit to 1.1.4 (with out of DST issue fix)
* Ensure JRuby doesn't count fresh, new, work threads as vacant


### rufus-scheduler 3.5.0 - released 2018-05-15

* Use fugit to parse durations
* Drop .parse_time_string and .parse_duration_string
* Use fugit to parse cronlines


### rufus-scheduler 3.4.2 - released 2017-05-24

(had yanked 3.4.1, going 3.4.2)


### rufus-scheduler 3.4.1 - released 2017-05-24

* Let #schedule accept a CronLine instance, gh-247


### rufus-scheduler 3.4.0 - released 2017-03-23

* Stop supporting Ruby &lt; 1.9
* Drop ZoTime for et-orbi Etorbi::EoTime, gh-240
* Fix for ZooKeeper example, thanks to @djrodgerspryor, gh-238


### rufus-scheduler 3.3.4 - released 2017-02-16

* More detailed "cannot determine timezone from nil" message, gh-237


### rufus-scheduler 3.3.3 - released 2017-01-29

* use Rails' timezone by default if Rails is present, gh-230, gh-233,
  thanks Alexander Deeb
* is_a?(Fixnum) replaced by is_a?(Integer), gh-232, thanks Cody Cutrer
* Fix for every double trigger, gh-231, thanks Sofia Bravo


### rufus-scheduler 3.3.2 - released 2017-01-05

* Fix ZoTime issue with `Time.zone.now #=> 'CST'`, thanks zzjin
* Fix cron weekdays + monthdays, by Dominik Sander, https://github.com/dsander
* Speedup CronLine#brute_frequency, by Dominik Sander
* Use object_id instead of hash to make Job id


### rufus-scheduler 3.3.1 - released 2016-12-03

* gh-222 fall back on `ENV['TZ']` when Time.now.zone is something
  like "中国标准时间" (ask for "Asia/Shanghai"), thanks to
  https://github.com/lovingyu


### rufus-scheduler 3.3.0 - released 2016-11-28

* Bring in Piavka's Job#trigger_off_schedule, gh-214
* Reject "day 0" in cronlines, thanks to Ramon Tayag, https://github.com/ramontayag
* Move away from `ENV['TZ']`, thanks to Akinori Musha, https://github.com/knu
* Fix .parse_to_time vs Date issue, as reported by @nsatragno


### rufus-scheduler 3.2.2 - released 2016-08-14

* job opt hash preservation, as suggested in gh-212, by https://github.com/d-m-u
* introduce Job#previous_time
* countered ActiveRecord 3.2.22 on gh-210, by https://github.com/paulodelgado


### rufus-scheduler 3.2.1 - released 2016-05-04

* accept `'* * * * 5L'` (last friday) (equivalent to `'* * * * 5#-1'`)
* CronLine#to_a (#to_array aliasing to it)
* simplify .parse_duration (and trim input)
* raise on `"*/0 * * * *"`, by https://github.com/simook
* introduce "days to end of month" in cron strings


### rufus-scheduler 3.2.0 - released 2015-12-28

* cache CronLine#brute_frequency results, gh-188 and gh-89
* "every" shift prevention by https://github.com/Korrigan
* Ruby warnings silenced by https://github.com/vivitar


### rufus-scheduler 3.1.10 - released 2015-11-18

* allow for `:first_in => 0`, gh-179 by https://github.com/JonMcPherson
  for https://github.com/Shopify/dashing/commit/ea3730fa4
* stop shipping specs in gem


### rufus-scheduler 3.1.9 - released 2015-11-12

* fix potential RuntimeError in CronLine#prev_second,
  by Alexandru https://github.com/alexandru-calinoiu


### rufus-scheduler 3.1.8 - released 2015-11-10

* stop jumping eagerly out of DST, fix for one hour jump when leaving DST
  thanks Alyssa http://github.com/alyssa


### rufus-scheduler 3.1.7 - released 2015-10-15

* ack #unscheduled_at in #scheduled?, by Claude https://github.com/claudeatsafe


### rufus-scheduler 3.1.6 - released 2015-10-01

* fix job id uniqueness (JRuby), thanks 김성식 https://github.com/kssminus


### rufus-scheduler 3.1.5 - released 2015-09-25

* fix for "not a valid cronline" on "mingw" Ruby distributions, gh-166


### rufus-scheduler 3.1.4 - released 2015/08/29

* fix cron issue reported by Jesse https://github.com/jhw-at-prosperworks-com


### rufus-scheduler 3.1.3 - released 2015/06/20

* prevent `Thread[:rufus_scheduler_time]` being nil, gh-156
* fix inconsistency in Job#start_work_thread


### rufus-scheduler 3.1.2 - released 2015/05/23

* avoid cron/:first_at infinite loop, thanks https://github.com/pouellet


### rufus-scheduler 3.1.1 - released 2015/04/19

* fix ZoTime.is_timezone? on OSX, thanks https://github.com/yaauie


### rufus-scheduler 3.1.0 - released 2015/04/18

* go without tzinfo (and its dependencies)
* include @ketan's #next_time improvements
* remove 2.x warning message on install


### rufus-scheduler 3.0.9 - released 2014/08/30

* fix TZ with underscores, thanks https://github.com/gnilrets
* integrate https://github.com/ecin Lock mecha


### rufus-scheduler 3.0.8 - released 2014/06/09

* handle TZInfo errors on DST transitions, thanks https://github.com/junhanamaki
* implement Scheduler#up?
* let schedule and schedule_at use Chronic if present
* let Rufus::Scheduler.parse use Chronic if present


### rufus-scheduler 3.0.7 - released 2014/03/18

* implement Scheduler #occurrences and #timeline, inspired by kreynolds
* implement Job #last_work_time and #mean_work_time
* implement Job#count
* add more info to the stderr error output (scheduler/tz info)
* prevent skipping a day on switch to summertime, gh-114, thanks Matteo


### rufus-scheduler 3.0.6 - released 2014/02/14

* avoid "can't be called from trap context" on Ruby 2.0, gh-98


### rufus-scheduler 3.0.5 - released 2014/01/30

* implement Job#call(do_rescue=false), gh-97
* implement `:first => :now` for repeat jobs, gh-96


### rufus-scheduler 3.0.4 - released 2014/01/19

* make CronLine#frequency faster (to avoid 20s schedule_cron times)


### rufus-scheduler 3.0.3 - released 2013/12/12

* CronLine#previous_time fix by Yassen Bantchev (https://github.com/yassenb)
* introduce ZookeptScheduler example in the readme
* rename #consider_lockfile to #lock and introduce #unlock


### rufus-scheduler 3.0.2 - released 2013/10/22

* default :max_work_threads to 28
* fix "rufus rushes to create work threads" issue, thanks Gatis Tomsons
* introduce Rufus::Scheduler::NotRunningError, thanks Gatis Tomsons


### rufus-scheduler 3.0.1 - released 2013/10/19

* fix post_install_message, thanks Ted Pennings
* bring back .parse_time_string and .parse_duration_string


### rufus-scheduler 3.0.0 - released 2013/10/02

* complete rewrite.
* introduce scheduler.interval('10s') { ... }


### rufus-scheduler 2.0.24 - released 2013/09/02

* lowered tzinfo dependency to &gt;= 0.3.22
  http://stackoverflow.com/questions/18551970


### rufus-scheduler 2.0.23 - released 2013/07/26

* mutex vs timeout fix by Tobias Kraze


### rufus-scheduler 2.0.22 - released 2013/07/16

* parse `"/10 * * * *"` again (like &lt;= 2.0.19 did), thanks @skrd


### rufus-scheduler 2.0.21 - released 2013/07/15

* add license (MIT) to gemspec file


### rufus-scheduler 2.0.20 - released 2013/07/15

* add Rufus::Scheduler.new (so that rs 3.0 quickstarts are OK with 2.0.20)
* implement CronLine#previous_time(now=Time.now) (Idea Matteo Cerutti)
* throw ArgumentError for invalid cron lines (Thanks Aimee Rose)
* cron 0 vs 24 hour case straightening (Thanks Aimee Rose)
* support for sun#L or sun#-2 in cron lines


### rufus-scheduler 2.0.19 - released 2013/05/07

* raise ArgumentError on &lt;= 0.0 "every" frequency (Thanks Lucy Fu)
* support multiple mutexes (Thanks Rainux Luo)


### rufus-scheduler 2.0.18 - released 2013/03/06

* support for "L" in cron lines (Thanks Andrew Davey)
* support for negative time strings (Thanks Danny "northox" Fullerton)
* reject invalid weekdays (Thanks pazustep)


### rufus-scheduler 2.0.17 - released 2012/06/14

* @andrehjr patch to make it work on Ruby 1.9.3
* raises ArgumentError on unknown/unsupported options (Idea Tero Tilus)


### rufus-scheduler 2.0.16 - released 2011/12/31

* hardened Rufus.parse_time_string
* running job thread: getting rid of the job pointer once job is done


### rufus-scheduler 2.0.15 - released 2011/12/20

* Scheduler#running_jobs (Thanks Louis Coilliot)


### rufus-scheduler 2.0.14 - released 2011/12/11

* Job #pause and #resume
* Scheduler #pause(job_or_job_id) and #resume(job_or_job_id)
* Scheduler#unschedule(job_or_job_id)


### rufus-scheduler 2.0.13 - released 2011/11/14

* cron lines now OK with "09". Thanks Anthony Lewis


### rufus-scheduler 2.0.12 - released 2011/10/28

* hardened exception handling. Thanks Sam Gibson
* accepting #handle_exception, #log_exception or #on_exception
* `scheduler.in '1s', :mutex => 'that_mutex_name'`


### rufus-scheduler 2.0.11 - released 2011/09/30

* require 'rufus-scheduler' works


### rufus-scheduler 2.0.10 - released 2011/06/26

* every and allow_overlapping now surviving exceptions. Thanks sha1dy


### rufus-scheduler 2.0.9 - released 2011/04/22

* `Scheduler#first_at` and `:discard_past => true`. Thanks concept47
* `Scheduler#cron` and monthdays (sun#2 or mon#1)
* `Scheduler#unschedule_by_tag(t)`


### rufus-scheduler 2.0.8 - released 2010/12/31

* issue with cron `"0 7-23/2 * * *"` fixed. Thanks Pickerel


### rufus-scheduler 2.0.7 - released 2010/11/09

* `:allow_overlapping => false`, thanks Adam Davies
* cron and timezones, thanks Tanzeeb Khalili
* `Scheduler#trigger_threads`, thanks Tim Uckun


### rufus-scheduler 2.0.6 - released 2010/05/01

* timeout jobs not outliving their parent job anymore, thanks Joel Wood


### rufus-scheduler 2.0.5 - released 2010/03/02

* fixed parse_time_string(s) issue, thanks Gonzalo Suarez


### rufus-scheduler 2.0.4 - released 2010/02/12

* addressing issue with every and timeout, thanks Tony Day


### rufus-scheduler 2.0.3 - released 2009/11/04

* made sure Schedulables with a call(job) method were OK when passed as second
  parameter (thanks Nate Wiger)


### rufus-scheduler 2.0.2 - released 2009/10/31

* unified JobQueue and CronJobQueue, and handed @last_second management to the
  latter
* #trigger_block method for easier override
* passing `:job => job` among Schedulable trigger parameters


### rufus-scheduler 2.0.1 - released 2009/05/07
### rufus-scheduler 2.0.0 - released 2009/05/07

...

## initial release

(was [openwferu-scheduler](https://rubygems.org/gems/openwferu-scheduler/versions) before that)

