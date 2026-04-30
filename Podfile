platform :ios, '15.0'

# **Dynamic** frameworks are loaded once per process; keep `abstract_target` so app + UI tests share
# the same pod versions. Linkage must be explicit — plain `use_frameworks!` can still resolve to
# static in some CocoaPods/Xcode combos.
use_frameworks! :linkage => :dynamic
inhibit_all_warnings!

abstract_target 'PostVaultPods' do
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Alamofire'
  pod 'RealmSwift'

  target 'PostVault' do
  end

  target 'PostVaultUITests' do
  end
end
