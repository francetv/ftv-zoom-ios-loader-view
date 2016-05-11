# francetv zoom Loader View Demo

This project is part of [francetv zoom open source projects](https://github.com/francetv/zoom-public) (iOS, Android and Angular).

## Summary

Simple Swift project demonstrating how the loader was made for **francetv zoom**,
using `CALayer` and `CABasicAnimation`.

![](Example.gif)

## Usage

Drag the **LoaderView.swift** file into your project and add the **LoaderBlack**
image to your assets.

Then, in a `UIViewController`, create a `LoaderView`,
set its constraints and add it to your view as follows:

```Swift
override func viewWillAppear(animated: Bool) {

    super.viewWillAppear(animated)
    addLoader()
}

private func addLoader() {

    let loader = LoaderView()

    let constraints = [
        NSLayoutConstraint(item: loader, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: loader.frame.width),
        NSLayoutConstraint(item: loader, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: loader.frame.height),
        NSLayoutConstraint(item: loader, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: loader, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
            toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)]

    view.addSubview(loader)
    view.addConstraints(constraints)
    view.setNeedsLayout()

    loader.startAnimation()
}
```

## Example

To try the example project, clone the repo, and run the project.

## Requirements

  + ARC
  + iOS 8

## License

This project is available under the MIT license. See the LICENSE file for more info.
