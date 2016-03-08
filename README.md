# SSColorfulRefresh
![](https://raw.githubusercontent.com/immrss/SSTableViewPopover/master/Demo.gif)

## Usage
You can set nil array to use default colors.
```objective-c
NSArray *array = @[[UIColor colorWithRed:175/255.0 green:18/255.0 blue:88/255.0 alpha:1],
                       [UIColor colorWithRed:244/255.0 green:13/255.0 blue:100/255.0 alpha:1],
                       [UIColor colorWithRed:90/255.0 green:13/255.0 blue:67/255.0 alpha:1],
                       [UIColor colorWithRed:244/255.0 green:222/255.0 blue:41/255.0 alpha:1],
                       [UIColor colorWithRed:179/255.0 green:197/255.0 blue:135/255.0 alpha:1],
                       [UIColor colorWithRed:18/255.0 green:53/255.0 blue:85/255.0 alpha:1]
                       ];
self.colorRefresh = [[SSColorfulRefresh alloc]initWithScrollView:self.tableView colors:array];
[self.colorRefresh addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];

```

## License
The project is available under the MIT license.
