require File.expand_path('./spec_helper', File.dirname(__FILE__))

describe "A class that can be unlocked" do
  before(:each) do
    @unlockable = Publication.create!
    @user = User.create!
  end
  
  it "should be able to be unlocked" do
    @unlockable.unlock(@user)
    
    @unlockable.unlocks.count.should eq(1)
  end
  
  it "should not create duplicate unlocks" do
    @unlockable.unlock(@user)
    @unlockable.unlock(@user)
        
    @unlockable.unlocks.count.should eq(1)
  end
  
  it "should be able to tell if it has been unlocked" do
    @unlockable.unlock(@user)
    
    @unlockable.unlocked?(@user).should be_true
  end
  
end
