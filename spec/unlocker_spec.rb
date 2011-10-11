require File.expand_path('./spec_helper', File.dirname(__FILE__))

describe "A class that can unlock" do
  before(:each) do
    @unlockable = Publication.create!
    @user = User.create!
  end
  
  it "should be able to unlock" do
    @user.unlock(@unlockable)
    
    @user.unlocks.count.should eq(1)
  end
  
  it "should not create duplicate unlocks" do
    @user.unlock(@unlockable)
    @user.unlock(@unlockable)
    
    @user.unlocks.count.should eq(1)
  end
  
  it "should be able to tell if an unlockable has been unlocked" do
    @user.unlock(@unlockable)
    
    @user.has_unlocked?(@unlockable).should be_true
  end
end
