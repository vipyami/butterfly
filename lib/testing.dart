// Copyright 2016 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

library flutter_ftw.testing;

import 'dart:html' as htm;
import 'ftw.dart';
import 'src/tree.dart';

ApplicationTester runTestApp(Widget topLevelWidget) {
  return new ApplicationTester(topLevelWidget);
}

class ApplicationTester {
  factory ApplicationTester(Widget topLevelWidget) {
    const flutterTestHostElementId = 'flutter-test-host-element';
    htm.Element hostElement = htm.document.querySelector('#$flutterTestHostElementId');
    if (hostElement != null) {
      hostElement.remove();
    }
    hostElement = new htm.DivElement()
      ..id = flutterTestHostElementId;
    htm.document.body.append(hostElement);
    Tree tree = new Tree(topLevelWidget, hostElement);
    ApplicationTester tester = new ApplicationTester._(hostElement, tree);
    tester.renderFrame();
    return tester;
  }

  ApplicationTester._(this.hostElement, this.tree);

  final htm.Element hostElement;
  final Tree tree;

  String get html => hostElement.innerHtml;

  htm.Element querySelector(String selector) =>
      hostElement.querySelector(selector);

  htm.ElementList<htm.Element> querySelectorAll(String selector) =>
      hostElement.querySelectorAll(selector);

  Node findNode(bool predicate(Node node)) {
    Node foundNode;
    void findTrackingNode(Node node) {
      if (predicate(node)) {
        foundNode = node;
      } else {
        node.visitChildren(findTrackingNode);
      }
    }
    tree.visitChildren(findTrackingNode);
    return foundNode;
  }

  Node findNodeOfType(Type type) =>
      findNode((node) => node.runtimeType == type);

  Node findNodeOfConfigurationType(Type type) =>
      findNode((node) => node.configuration.runtimeType == type);

  void renderFrame() {
    tree.renderFrame();
  }
}