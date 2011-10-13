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
    
    lambda { @user.unlock(@unlockable) }.should raise_error(AlreadyUnlocked)
    
    @user.unlocks.count.should eq(1)
  end
  
  it "should be able to tell if an unlockable has been unlocked" do
    @user.unlock(@unlockable)
    
    @user.has_unlocked?(@unlockable).should be_true
  end
  
  it "should be able to set a global unlock limit" do
    @user.max_unlocks = 2
    @user.reload
    
    @user.max_unlocks.should eq(2)
  end
  
  it "should be able to set a model specific unlock limit" do
    @user.max_unlocks_for_publication = 2
    @user.reload
    
    @user.max_unlocks_for_publication.should eq(2)
  end
  
  it "should raise a method missing when max_unlocks_for is given an invalid class name" do
    lambda { 
      @user.max_unlocks_for_bad_class = 2
    }.should raise_error(NoMethodError)
  end
  
  context "with a global download limit" do
    before(:each) do
      @user.max_unlocks = 2
      @user.reload
      
      @user.unlock(@unlockable)
    end
    
    it "should be able to determine that we are under our global unlock limit" do
      @user.can_unlock?(Publication.create!).should be_true
    end
    
    it "should be able to determine that we are over our global unlock limit" do
      unlockable2 = Publication.create!
      @user.unlock(unlockable2)
      
      @user.can_unlock?(Publication.create!).should be_false
    end
    
    it "should raise an exception if we have reached the unlock limit" do
      @user.unlock(Publication.create)
      
      lambda { @user.unlock(Publication.create) }.should raise_error(UnlockLimitReached)
    end
    
    it "should give us the total number of available unlocks remaining" do
      @user.unlocks_remaining.should == 1
    end
    
    it "should tell us if we have unlocks remaining" do
      @user.unlocks_remaining?.should be_true
    end
    
    it "should tell us if we don't have unlocks remaining" do
      @user.unlock(Publication.create!)
      @user.unlocks_remaining?.should be_false
    end
  end
  
  context "with a Publication download limit" do
    before(:each) do
      @user.max_unlocks_for_publication = 2
      @user.reload
      @user.unlock(@unlockable)
    end
    
    it "should be able to determine that we are under our Publication unlock limit" do
      @user.can_unlock?(@unlockable).should be_true
    end
    
    it "should be able to determine that we are over our Publication unlock limit" do
      @user.unlock(Publication.create!)

      @user.can_unlock?(Publication.create!).should be_false
    end

    it "should be able to determine that we have not reached our Video unlock limit" do
      @user.unlock(Publication.create!)
      
      @user.can_unlock?(Video.create!).should be_true
    end
    
    it "should give us the number of available publication unlocks remaining" do
      @user.publication_unlocks_remaining.should == 1
    end
    
    it "should tell us if we have publication unlocks remaining" do
      @user.publication_unlocks_remaining?.should be_true
    end
    
    it "should tell us if we don't have publication unlocks remaining" do
      @user.unlock(Publication.create!)
      @user.publication_unlocks_remaining?.should be_false
    end
  end
  
  context "with default global and publication limits" do
    before(:each) do
      @guest = Guest.create!
      @guest.unlock(@unlockable)
    end
    
    it "should be able to determine that we have reached our publication unlock limit" do
      @guest.can_unlock?(Publication.create!).should be_false
    end
    
    it "should be able to determine that we have reached our global unlock limit" do
      @guest.unlock(Video.create!)
      
      @guest.can_unlock?(Video.create!).should be_false
    end
    
    it "should respect an overriden global unlock limit" do
      @guest.max_unlocks = 3
      @guest.save!
      @guest.reload
      
      @guest.unlock(Video.create!)
      
      @guest.can_unlock?(Video.create!).should be_true
    end
    
    it "should respect an overriden Model limit" do
      @guest.max_unlocks_for_publication = 3
      @guest.max_unlocks = 5
      @guest.save!
      @guest.reload
      
      @guest.unlock(Publication.create!)
      
      @guest.can_unlock?(Publication.create!).should be_true    
    end
  end
end
