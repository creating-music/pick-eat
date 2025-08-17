enum DislikeCategory {
  seafood('해산물'),
  meat('육류'),
  beef('소고기'),
  pork('돼지고기'),
  chicken('닭고기'),
  lamb('양고기'),
  vegetable('채소'),
  rawFish('회'),
  organ('내장'),
  noodle('면'),
  rice('밥'),
  soup('국물'),
  spicy('매운 것'),
  greasy('느끼한 것'),
  cold('차가운 것'),
  warm('따듯한 것');

  const DislikeCategory(this.displayName);
  final String displayName;
}
