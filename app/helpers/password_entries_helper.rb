module PasswordEntriesHelper
  def generatePassword length
    characterArray = [('A'..'Z'), ('a'..'z'), (0..9)].map { |chr| chr.to_a }.flatten
    (0...length).map { characterArray[rand(characterArray.length)] }.join
  end
end
